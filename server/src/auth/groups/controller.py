from typing import  List
from uuid import UUID
from fastapi import APIRouter,status

from . import model
from ...database.core import DbSession
from . import service
from ...rate_limiting import limiter
from ..service import CurrentUser
router = APIRouter(
    prefix='/group',
    tags= ['group']
)

@router.post("/",response_model=model.GroupResponse,status_code=status.HTTP_201_CREATED)
def create_group(db:DbSession,group:model.CreateGroup,current_user: CurrentUser):
    return service.create_group(current_user,db,group)


@router.get("/",response_model=model.GroupResponse)
def get_groups(db:DbSession, current_user: CurrentUser):
    return service.get_groups(current_user,db)

@router.get("/{group_id}",response_model=model.GroupResponse)
def get_group(db:DbSession, group_id:UUID, current_user:CurrentUser):
    return service.get_group_by_id(current_user,db,group_id)


@router.put("/{group_id}",response_model=model.GroupResponse)
def update_group(db:DbSession,group_id:UUID,group_update: model.CreateGroup,current_user:CurrentUser):
    return service.update_group(current_user,db,group_id, group_update)

@router.delete("/{group_id}",status_code=status.HTTP_204_NO_CONTENT)
def delete_group(db:DbSession,group_id: UUID, current_user: CurrentUser):
    return service.delete_group(current_user,db,group_id)


