from datetime import datetime
from uuid import UUID
from typing import Optional
from pydantic import BaseModel, ConfigDict


class CreateGroup(BaseModel):
    name: str
    description: Optional[str] = None



class GroupResponse(BaseModel):
    id:UUID
    name: str
    description: Optional[str] = None
    user_id: UUID
    created_at: datetime
    book_id: Optional[UUID] = None
    book_title: Optional[str] = None
    book_cover_url: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)
