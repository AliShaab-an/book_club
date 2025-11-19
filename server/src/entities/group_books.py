import enum
from sqlalchemy import Column,  ForeignKey,DateTime, Enum
from sqlalchemy.dialects.postgresql import UUID
from ..database.core import Base
from datetime import datetime, timezone

class ReadingStatus(enum.Enum):
    not_started = "not started"
    reading = "reading"
    finished = "finished"

class GroupBook(Base):
    __tablename__ = 'group_book'

    id = Column(UUID(as_uuid=True),primary_key=True,nullable=False)
    group_id = Column(UUID(as_uuid=True), ForeignKey('group.id'),nullable=False)
    book_id = Column(UUID(as_uuid=True), ForeignKey('books.id'),nullable=False)
    selected_date = Column(DateTime,default=lambda : datetime.now(timezone.utc), nullable=False)
    status = Column(Enum(ReadingStatus),nullable=False, default=ReadingStatus.not_started)

    def __repr__(self):
        return f"<Group<status='{self.status}''>"
