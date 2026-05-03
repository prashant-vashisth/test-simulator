import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ....core.database import get_db
from ....models.child import Child
from ....schemas.child import ChildOut, ChildUpdate
from ....schemas.session import SessionSummaryOut, TopicPerformanceOut
from ....models.session import TestSession
from ....models.catalogue import TestType, Subject, Grade
from ....services.analytics import get_topic_performance, generate_recommendations

router = APIRouter()


@router.get("", response_model=list[ChildOut])
async def list_children(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Child).order_by(Child.display_order))
    return result.scalars().all()


@router.get("/{child_id}", response_model=ChildOut)
async def get_child(child_id: uuid.UUID, db: AsyncSession = Depends(get_db)):
    child = await db.get(Child, child_id)
    if not child:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Child not found")
    return child


@router.patch("/{child_id}", response_model=ChildOut)
async def update_child(child_id: uuid.UUID, body: ChildUpdate, db: AsyncSession = Depends(get_db)):
    child = await db.get(Child, child_id)
    if not child:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Child not found")
    if body.avatar_url is not None:
        child.avatar_url = body.avatar_url
    db.add(child)
    await db.commit()
    await db.refresh(child)
    return child


@router.get("/{child_id}/sessions", response_model=list[SessionSummaryOut])
async def get_child_sessions(
    child_id: uuid.UUID,
    limit: int = 5,
    db: AsyncSession = Depends(get_db),
):
    rows = (
        await db.execute(
            select(TestSession, TestType.name, Subject.name, Grade.name)
            .join(TestType, TestType.id == TestSession.test_type_id)
            .join(Subject, Subject.id == TestSession.subject_id)
            .join(Grade, Grade.id == TestSession.grade_id)
            .where(TestSession.child_id == child_id, TestSession.status == "completed")
            .order_by(TestSession.started_at.desc())
            .limit(limit)
        )
    ).all()

    return [
        SessionSummaryOut(
            **{c.key: getattr(session, c.key) for c in TestSession.__table__.columns},
            test_type_name=tt_name,
            subject_name=sub_name,
            grade_name=grade_name,
        )
        for session, tt_name, sub_name, grade_name in rows
    ]


@router.get("/{child_id}/topic-performance", response_model=list[TopicPerformanceOut])
async def child_topic_performance(
    child_id: uuid.UUID,
    subject_id: uuid.UUID | None = None,
    grade_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db),
):
    return await get_topic_performance(db=db, child_id=child_id, subject_id=subject_id, grade_id=grade_id)


@router.get("/{child_id}/recommendations", response_model=list[str])
async def child_recommendations(
    child_id: uuid.UUID,
    subject_id: uuid.UUID | None = None,
    grade_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db),
):
    perf = await get_topic_performance(db=db, child_id=child_id, subject_id=subject_id, grade_id=grade_id)
    return generate_recommendations(perf)
