from typing import Optional
from datetime import datetime
from pydantic import BaseModel, ConfigDict
from uuid import UUID

class SelectBookRequest(BaseModel):
    group_id: UUID
    book_id: UUID
    status: Optional[str] = "not_started"


class GroupBookResponse(BaseModel):
    id: UUID
    group_id: UUID
    book_id: UUID
    selected_date: datetime
    status: str

    model_config = ConfigDict(from_attributes=True)