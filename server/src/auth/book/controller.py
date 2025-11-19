from typing import  List
from fastapi import APIRouter,status, Query

from . import model
from .model import BookSearchResult, AddBook
from ...database.core import DbSession
from . import service
from ...rate_limiting import limiter
router = APIRouter(
    prefix='/book',
    tags= ['Book']
)


@router.get("/search",response_model=List[BookSearchResult])
async def search_book(query: str = Query(...,min_length = 1)):
    return await service.search_book(query)



@router.post("/",response_model=model.AddBook)
def add_book(db: DbSession,book: AddBook):
    return service.add_book(db,book)







