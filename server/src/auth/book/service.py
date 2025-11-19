import httpx
from fastapi import HTTPException
from sqlalchemy.orm import Session
from .model import BookSearchResult, AddBook
from typing import List
from ...entities.book import Book


async def search_book(query: str) -> List[BookSearchResult]:
    url = f"https://www.googleapis.com/books/v1/volumes?q={query}"

    async with httpx.AsyncClient() as client:
         response = await client.get(url);

         if response.status_code != 200:
            raise HTTPException(
                status_code= 500,
                detail= "failed to fetch books"
            )

         items = response.json().get("items", [])
         results = []

         for item in items:
             info = item.get("volumeInfo", {})
             image_links = info.get("imageLinks", {})
             authors = info.get("authors", [])

             results.append(BookSearchResult(
                 title=info.get("title", "Unknown Title"),
                 author=", ".join(authors) if authors else None,
                 description=info.get("description"),
                 cover_image=image_links.get("thumbnail"),
                 page_count = info.get("pageCount"),
                 language= info.get("language"),
                 external_id=item.get("id")
             ))

         return results

def add_book(db:Session,book:AddBook) -> Book:

    if book.external_id:
        existing = db.query(Book).filter_by(external_id= book.external_id).first()
        if existing:
            return existing


    new_book = Book(
        title = book.title,
        author = book.author,
        description = book.description,
        pages = book.pages,
        cover_image = book.cover_image,
        source = book.source,
        external_id = book.external_id,
    )

    db.add(new_book)
    db.commit()
    db.refresh()
    return new_book