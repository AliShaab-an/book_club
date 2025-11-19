from datetime import datetime
from uuid import UUID
from typing import Optional
from pydantic import BaseModel, ConfigDict


class CreateGroup(BaseModel):
    name: str
    description: Optional[str] = None
    user_id: UUID



class GroupResponse(BaseModel):
    id:UUID
    name: str
    description: Optional[str] = None
    user_id: UUID
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
