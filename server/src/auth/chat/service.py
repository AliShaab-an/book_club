from datetime import datetime, timezone
import json
from  typing import  List,Dict
from uuid import UUID
from sqlalchemy.orm import Session
from fastapi import WebSocket, WebSocketDisconnect
from src.auth.chat.model import CreateMessage, MessageResponse
from ...entities.disscusion_messages import DiscussionMessages

class ConnectionManager:
    def __init__(self):
        self.active_connection: Dict[UUID,List[WebSocket]] = {}

    async def connect(self,group_id:UUID,websocket:WebSocket):
        await websocket.accept()
        if group_id not in self.active_connection:
            self.active_connection[group_id] = []
        self.active_connection[group_id].append(websocket)
    def disconnect(self,group_id:UUID,websocket: WebSocket):
        self.active_connection[group_id].remove(websocket)
        if not self.active_connection[group_id]:
            del self.active_connection[group_id]

    async def send_message(self,message:str,websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self,group_id:UUID,message:str):
        if group_id in self.active_connection:
            for connection in self.active_connection[group_id]:
                await connection.send_text(message)


manger = ConnectionManager()


async def group_chat(websocket: WebSocket, group_id: UUID, db:Session):

    await manger.connect(str(group_id),websocket)

    try:
        while True:
            data = await websocket.receive_text()
            try:
                msg = CreateMessage.parse_raw(data)
            except Exception as e:
                await websocket.send_text(f"Invalid data format: {e}")
                continue


            discussion_msg = DiscussionMessages(
                group_id = msg.group_id,
                user_id = msg.user_id,
                message = msg.content,
                timestamp = datetime.now(timezone.utc)
            )

            db.add(discussion_msg)
            db.commit()
            db.refresh(discussion_msg)

            response = MessageResponse(
                id = discussion_msg.id,
                group_id= discussion_msg.group_id,
                user_id= discussion_msg.user_id,
                message = discussion_msg.message,
                timestamp= discussion_msg.timestamp
            )

            await manger.broadcast(str(group_id),response.model_dump_json())
    except WebSocketDisconnect:
        manger.disconnect(str(group_id), websocket)



