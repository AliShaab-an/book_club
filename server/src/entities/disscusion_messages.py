from sqlalchemy import Column,ForeignKey, DateTime, String
from sqlalchemy.dialects.postgresql import UUID
from ..database.core import Base
from datetime import datetime,timezone


class DiscussionMessages(Base):
    __tablename__ = 'discussion_messages'

    id = Column(UUID(as_uuid=True),primary_key=True,nullable=False)
    group_id = Column(UUID(as_uuid=True), ForeignKey('group.id'),nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey('users.id'),nullable=False)
    timestamp = Column(DateTime,default=lambda: datetime.now(timezone.utc),nullable=False)
    message = Column(String, nullable=False)