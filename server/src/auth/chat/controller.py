from fastapi import APIRouter,WebSocket
from uuid import UUID
from ...database.core import DbSession
from . import service


router = APIRouter(
    prefix='/chat',
    tags=["Group Chats"]
)


@router.websocket("/{group_id}")
async def chat_endpoint(websocket:WebSocket,group_id:UUID,db:DbSession):
     await service.group_chat(websocket,group_id,db)



@router.get("/")
def websocket_info():
    """
        📡 WebSocket endpoint for group discussion.

        - Connect to `/ws/{group_id}` via WebSocket.
        - Payload format (JSON):
          ```json
          {
            "group_id": "uuid",
            "user_id": "uuid",
            "content": "Your message here"
          }
          ```
        - Real-time chat, stored in DB and broadcasted to group.

        Note: This endpoint is for **documentation only**.
        """
    return {"detail": "See description for WebSocket usage"}


