from typing import  List
from uuid import UUID
from fastapi import APIRouter,status, Query

from . import model
from .model import BookSearchResult, AddBook
from ...database.core import DbSession
from . import service
from ...rate_limiting import limiter
from ..service import CurrentUser
router = APIRouter(
    prefix='/book',
    tags= ['Book']
)


@router.get("/search",response_model=List[BookSearchResult])
async def search_book(query: str = Query(...,min_length = 1)):
    return await service.search_book(query)


@router.post("/",response_model=model.BookResponse)
def add_book(db: DbSession, book: AddBook, current_user: CurrentUser):
    return service.add_book_to_library(db, book, current_user)


@router.get("/library",response_model=List[model.UserBookResponse])
def get_user_library(db: DbSession, current_user: CurrentUser):
    return service.get_user_library(current_user, db)


@router.post("/library/{book_id}",status_code=status.HTTP_201_CREATED)
def add_to_library(db: DbSession, book_id: UUID, current_user: CurrentUser, status_param: str = Query("want_to_read")):
    return service.add_to_user_library(current_user, db, book_id, status_param)


@router.delete("/library/{book_id}",status_code=status.HTTP_204_NO_CONTENT)
def remove_from_library(db: DbSession, book_id: UUID, current_user: CurrentUser):
    return service.remove_from_user_library(current_user, db, book_id)







