from datetime import datetime,timezone
from sqlalchemy import Column, ForeignKey, DateTime
from sqlalchemy.dialects.postgresql import UUID
import uuid
from ..database.core import Base


class GroupMember(Base):
    __tablename__ = 'group_members'

    id = Column(UUID(as_uuid=True),primary_key=True,default=uuid.uuid4)
    group_id = Column(UUID(as_uuid=True), ForeignKey("group.id"),nullable=False)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"), nullable=False)
    joined_at = Column(DateTime, default=lambda: datetime.now(timezone.utc), nullable=False)
