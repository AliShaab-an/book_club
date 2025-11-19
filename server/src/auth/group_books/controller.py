from fastapi import APIRouter,status
from . import model
from ...database.core import DbSession
from . import service
router = APIRouter(
    prefix="/group_book",
    tags=["GroupBook"]
)

@router.post("/select-book",response_model=model.GroupBookResponse,status_code=status.HTTP_202_ACCEPTED)
def select_book(data: model.SelectBookRequest,db: DbSession):
    return service.select_book_for_group(data,db)