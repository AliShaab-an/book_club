from sqlalchemy import Column, String, Integer
from sqlalchemy.dialects.postgresql import UUID
import uuid
from ..database.core import Base


class Book(Base):
    __tablename__ = 'books'

    id = Column(UUID(as_uuid=True),primary_key=True,default=uuid.uuid4)
    title = Column(String,nullable=False)
    author = Column(String, nullable=True)
    description = Column(String,nullable=True)
    pages = Column(Integer,nullable=True)
    cover_image = Column(String, nullable=True)
    source = Column(String, nullable=True)
    external_id = Column(String, nullable=True)


    def __repr__(self):
        return f"<Group<name='{self.title}',author='{self.author}',description='{self.description}',No.pages='{self.pages}'>"