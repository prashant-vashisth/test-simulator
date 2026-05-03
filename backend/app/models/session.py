import uuid
from datetime import datetime
from sqlalchemy import SmallInteger, Integer, Numeric, Boolean, ForeignKey, DateTime, func
from sqlalchemy import Enum as SAEnum, ARRAY
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from ..core.database import Base


class TestSession(Base):
    __tablename__ = "test_sessions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    child_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("children.id"), nullable=False)
    test_type_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("test_types.id"), nullable=False)
    subject_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("subjects.id"), nullable=False)
    grade_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("grades.id"), nullable=False)
    difficulty: Mapped[str] = mapped_column(SAEnum("easy", "medium", "hard", name="difficulty_enum"), nullable=False)
    total_questions: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    ended_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    status: Mapped[str] = mapped_column(
        SAEnum("in_progress", "completed", "abandoned", name="test_status_enum"),
        nullable=False,
        default="in_progress",
    )
    correct_count: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    score_percentage: Mapped[float | None] = mapped_column(Numeric(5, 2))
    interruption_count: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    child: Mapped["Child"] = relationship(back_populates="sessions")
    answers: Mapped[list["SessionAnswer"]] = relationship(back_populates="session", cascade="all, delete-orphan")


class SessionAnswer(Base):
    __tablename__ = "session_answers"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("test_sessions.id", ondelete="CASCADE"), nullable=False)
    question_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("questions.id"), nullable=False)
    question_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    selected_option_ids: Mapped[list[uuid.UUID]] = mapped_column(ARRAY(UUID(as_uuid=True)), nullable=False, default=list)
    is_correct: Mapped[bool | None] = mapped_column(Boolean)
    time_taken_seconds: Mapped[int | None] = mapped_column(SmallInteger)
    answered_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    session: Mapped["TestSession"] = relationship(back_populates="answers")


class TopicPerformance(Base):
    __tablename__ = "topic_performance"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    child_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("children.id"), nullable=False)
    topic_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("topics.id"), nullable=False)
    total_attempts: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    correct_attempts: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    last_attempted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    child: Mapped["Child"] = relationship(back_populates="topic_performances")
