from pydantic import BaseModel, ConfigDict
from uuid import UUID
from datetime import datetime

class CreateMessage(BaseModel):
    group_id: UUID
    user_id:UUID
    content: str


class MessageResponse(BaseModel):
    id: UUID
    group_id: UUID
    user_id: UUID
    content: str
    timestamp: datetime

    model_config = ConfigDict(from_attributes= True)