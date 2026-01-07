from sqlalchemy import Column, ForeignKey, DateTime, String
from sqlalchemy.dialects.postgresql import UUID
from ..database.core import Base
from datetime import datetime, timezone
import uuid

class UserBook(Base):
    __tablename__ = 'user_books'

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey('users.id'), nullable=False)
    book_id = Column(UUID(as_uuid=True), ForeignKey('books.id'), nullable=False)
    status = Column(String, nullable=False, default='want_to_read')  # want_to_read, reading, finished
    progress = Column(String, nullable=True)  # Page number or percentage
    added_at = Column(DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime, nullable=False, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    def __repr__(self):
        return f"<UserBook(user_id='{self.user_id}', book_id='{self.book_id}', status='{self.status}')>"
