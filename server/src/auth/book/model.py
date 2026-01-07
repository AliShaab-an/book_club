from pydantic import BaseModel, ConfigDict
from typing import Optional
from uuid import UUID
from datetime import datetime

class AddBook(BaseModel):
    title: str
    author: Optional[str]
    description: Optional[str]
    pages: Optional[int]
    cover_image: Optional[str]
    source: Optional[str] = "manual"
    external_id: Optional[str] = None

class BookResponse(BaseModel):
    id: UUID
    title: str
    author: Optional[str]
    description: Optional[str]
    pages: Optional[int]
    cover_image: Optional[str]
    source: Optional[str]
    external_id: Optional[str]

    model_config = ConfigDict(from_attributes=True)

class BookSearchResult(BaseModel):
    title: str
    author: Optional[str]
    description: Optional[str]
    cover_image: Optional[str]
    page_count: Optional[int]
    language: Optional[str]
    external_id: Optional[str]

class UserBookResponse(BaseModel):
    id: UUID
    title: str
    author: Optional[str]
    cover_image: Optional[str]
    status: str
    progress: Optional[str]
    added_at: datetime
    
    model_config = ConfigDict(from_attributes=True)