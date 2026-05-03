import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ....core.database import get_db
from ....models.session import TestSession, SessionAnswer
from ....models.question import Question, AnswerOption
from ....schemas.session import SessionCreate, SessionOut, AnswerSubmit, AnswerOut
from ....schemas.question import QuestionOut, QuestionWithAnswers
from ....services.question_selector import select_questions
from ....services.analytics import complete_session

router = APIRouter()


@router.post("", response_model=SessionOut, status_code=status.HTTP_201_CREATED)
async def create_session(body: SessionCreate, db: AsyncSession = Depends(get_db)):
    questions = await select_questions(
        db=db,
        test_type_id=body.test_type_id,
        subject_id=body.subject_id,
        grade_id=body.grade_id,
        difficulty=body.difficulty,
        num_questions=body.num_questions,
    )
    if not questions:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="No questions found for the selected test configuration. Please load questions via the pipeline.",
        )

    session = TestSession(
        child_id=body.child_id,
        test_type_id=body.test_type_id,
        subject_id=body.subject_id,
        grade_id=body.grade_id,
        difficulty=body.difficulty,
        total_questions=len(questions),
    )
    db.add(session)
    await db.flush()  # get session.id

    # Pre-create answer slots so the frontend knows the question order
    for order, question in enumerate(questions, start=1):
        db.add(SessionAnswer(
            session_id=session.id,
            question_id=question.id,
            question_order=order,
        ))

    await db.commit()
    await db.refresh(session)
    return session


@router.get("/{session_id}", response_model=SessionOut)
async def get_session(session_id: uuid.UUID, db: AsyncSession = Depends(get_db)):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    return session


@router.get("/{session_id}/questions", response_model=list[QuestionOut])
async def get_session_questions(session_id: uuid.UUID, db: AsyncSession = Depends(get_db)):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")

    answer_rows = (
        await db.execute(
            select(SessionAnswer)
            .where(SessionAnswer.session_id == session_id)
            .order_by(SessionAnswer.question_order)
        )
    ).scalars().all()

    question_ids = [a.question_id for a in answer_rows]
    questions = (
        await db.execute(select(Question).where(Question.id.in_(question_ids)))
    ).scalars().unique().all()

    options_map: dict[uuid.UUID, list[AnswerOption]] = {}
    opts = (
        await db.execute(
            select(AnswerOption)
            .where(AnswerOption.question_id.in_(question_ids))
            .order_by(AnswerOption.display_order)
        )
    ).scalars().all()
    for opt in opts:
        options_map.setdefault(opt.question_id, []).append(opt)

    q_by_id = {q.id: q for q in questions}
    result = []
    for aid in question_ids:
        q = q_by_id.get(aid)
        if q:
            q.options = options_map.get(q.id, [])
            result.append(q)
    return result


@router.post("/{session_id}/answers", response_model=AnswerOut)
async def submit_answer(
    session_id: uuid.UUID,
    body: AnswerSubmit,
    db: AsyncSession = Depends(get_db),
):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    if session.status != "in_progress":
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Session is not in progress")

    # Look up pre-created answer slot
    answer_row = (
        await db.execute(
            select(SessionAnswer).where(
                SessionAnswer.session_id == session_id,
                SessionAnswer.question_id == body.question_id,
            )
        )
    ).scalar_one_or_none()

    if not answer_row:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Question not part of this session")

    # Determine correctness
    correct_option_ids = set(
        row.id
        for row in (
            await db.execute(
                select(AnswerOption)
                .where(AnswerOption.question_id == body.question_id, AnswerOption.is_correct.is_(True))
            )
        ).scalars().all()
    )
    is_correct = set(body.selected_option_ids) == correct_option_ids

    answer_row.selected_option_ids = body.selected_option_ids
    answer_row.is_correct = is_correct
    answer_row.time_taken_seconds = body.time_taken_seconds
    db.add(answer_row)
    await db.commit()
    await db.refresh(answer_row)
    return answer_row


@router.patch("/{session_id}/complete", response_model=SessionOut)
async def complete_session_endpoint(
    session_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    if session.status == "completed":
        return session
    return await complete_session(db=db, session=session)


@router.patch("/{session_id}/abandon", response_model=SessionOut)
async def abandon_session(
    session_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    if session.status == "in_progress":
        session.status = "abandoned"
        db.add(session)
        await db.commit()
        await db.refresh(session)
    return session


@router.patch("/{session_id}/interruption", response_model=SessionOut)
async def record_interruption(
    session_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    if session.status == "in_progress":
        session.interruption_count += 1
        db.add(session)
        await db.commit()
        await db.refresh(session)
    return session


@router.get("/{session_id}/results", response_model=dict)
async def get_session_results(
    session_id: uuid.UUID,
    db: AsyncSession = Depends(get_db),
):
    """Returns the full session result with questions, correct answers, and explanations."""
    session = await db.get(TestSession, session_id)
    if not session:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Session not found")
    if session.status not in ("completed", "abandoned"):
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="Session not yet completed")

    answers = (
        await db.execute(
            select(SessionAnswer)
            .where(SessionAnswer.session_id == session_id)
            .order_by(SessionAnswer.question_order)
        )
    ).scalars().all()

    question_ids = [a.question_id for a in answers]
    questions = (
        await db.execute(select(Question).where(Question.id.in_(question_ids)))
    ).scalars().unique().all()
    opts = (
        await db.execute(
            select(AnswerOption)
            .where(AnswerOption.question_id.in_(question_ids))
            .order_by(AnswerOption.display_order)
        )
    ).scalars().all()

    opts_by_q: dict[uuid.UUID, list[AnswerOption]] = {}
    for opt in opts:
        opts_by_q.setdefault(opt.question_id, []).append(opt)

    q_by_id = {q.id: q for q in questions}

    question_results = []
    for answer in answers:
        q = q_by_id.get(answer.question_id)
        if not q:
            continue
        options = opts_by_q.get(q.id, [])
        question_results.append({
            "question_order": answer.question_order,
            "question_id": str(q.id),
            "question_text": q.question_text,
            "passage": q.passage,
            "question_type": q.question_type,
            "difficulty": q.difficulty,
            "explanation": q.explanation,
            "options": [
                {
                    "id": str(o.id),
                    "label": o.option_label,
                    "text": o.option_text,
                    "is_correct": o.is_correct,
                }
                for o in options
            ],
            "selected_option_ids": [str(x) for x in answer.selected_option_ids],
            "is_correct": answer.is_correct,
            "time_taken_seconds": answer.time_taken_seconds,
        })

    return {
        "session_id": str(session.id),
        "status": session.status,
        "total_questions": session.total_questions,
        "correct_count": session.correct_count,
        "score_percentage": float(session.score_percentage) if session.score_percentage is not None else None,
        "interruption_count": session.interruption_count,
        "started_at": session.started_at.isoformat(),
        "ended_at": session.ended_at.isoformat() if session.ended_at else None,
        "questions": question_results,
    }
