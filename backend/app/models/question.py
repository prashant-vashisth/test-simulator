import uuid
from datetime import datetime
from sqlalchemy import String, Text, SmallInteger, Integer, Boolean, ForeignKey, DateTime, func
from sqlalchemy import Enum as SAEnum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.dialects.postgresql import UUID
from ..core.database import Base


class Question(Base):
    __tablename__ = "questions"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    topic_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("topics.id"), nullable=False)
    grade_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("grades.id"), nullable=False)
    test_type_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("test_types.id"), nullable=False)
    question_text: Mapped[str] = mapped_column(Text, nullable=False)
    passage: Mapped[str | None] = mapped_column(Text)
    image_url: Mapped[str | None] = mapped_column(Text)
    question_type: Mapped[str] = mapped_column(
        SAEnum("single_choice", "multiple_choice", name="question_type_enum"),
        nullable=False,
        default="single_choice",
    )
    difficulty: Mapped[str] = mapped_column(
        SAEnum("easy", "medium", "hard", name="difficulty_enum"),
        nullable=False,
        default="medium",
    )
    points: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=1)
    explanation: Mapped[str | None] = mapped_column(Text)
    source_file: Mapped[str | None] = mapped_column(String(200))
    source_row: Mapped[int | None] = mapped_column(Integer)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    topic: Mapped["Topic"] = relationship(back_populates="questions")
    options: Mapped[list["AnswerOption"]] = relationship(back_populates="question", order_by="AnswerOption.display_order", cascade="all, delete-orphan")


class AnswerOption(Base):
    __tablename__ = "answer_options"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    option_label: Mapped[str] = mapped_column(String(1), nullable=False)
    option_text: Mapped[str] = mapped_column(Text, nullable=False)
    is_correct: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    display_order: Mapped[int] = mapped_column(SmallInteger, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    question: Mapped["Question"] = relationship(back_populates="options")
