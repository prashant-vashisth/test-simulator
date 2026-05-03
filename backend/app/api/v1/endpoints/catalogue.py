import uuid
from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from ....core.database import get_db
from ....models.catalogue import TestType, Subject, Grade, TestTypeGrade, Topic
from ....schemas.catalogue import TestTypeOut, SubjectOut, GradeOut, TopicOut

router = APIRouter()


@router.get("/test-types", response_model=list[TestTypeOut])
async def list_test_types(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(TestType).order_by(TestType.name))
    return result.scalars().all()


@router.get("/grades", response_model=list[GradeOut])
async def list_grades(
    test_type_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Grade).order_by(Grade.level)
    if test_type_id:
        stmt = (
            select(Grade)
            .join(TestTypeGrade, TestTypeGrade.grade_id == Grade.id)
            .where(TestTypeGrade.test_type_id == test_type_id)
            .order_by(Grade.level)
        )
    result = await db.execute(stmt)
    return result.scalars().all()


@router.get("/subjects", response_model=list[SubjectOut])
async def list_subjects(
    test_type_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Subject).order_by(Subject.display_order)
    if test_type_id:
        stmt = stmt.where(Subject.test_type_id == test_type_id)
    result = await db.execute(stmt)
    return result.scalars().all()


@router.get("/topics", response_model=list[TopicOut])
async def list_topics(
    subject_id: uuid.UUID | None = None,
    grade_id: uuid.UUID | None = None,
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Topic).order_by(Topic.display_order)
    if subject_id:
        stmt = stmt.where(Topic.subject_id == subject_id)
    if grade_id:
        stmt = stmt.where(Topic.grade_id == grade_id)
    result = await db.execute(stmt)
    return result.scalars().all()
