from sqlalchemy import Column, String, ForeignKey, DateTime
from sqlalchemy.dialects.postgresql import UUID
import uuid
from ..database.core import Base
from datetime import datetime,timezone

class Group(Base):
    __tablename__ = 'group'

    id = Column(UUID(as_uuid=True),primary_key=True,default=uuid.uuid4)
    name = Column(String,nullable=False)
    description = Column(String,nullable=True)
    user_id = Column(UUID(as_uuid=True), ForeignKey('users.id'), nullable=False)
    created_at = Column(DateTime,nullable=False,default=lambda:datetime.now(timezone.utc))

    def __repr__(self):
        return f"<Group<name='{self.name}',description='{self.description}',created_at='{self.created_at}'>"