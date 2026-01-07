import httpx
from fastapi import HTTPException
from sqlalchemy.orm import Session
from .model import BookSearchResult, AddBook, UserBookResponse
from typing import List
from ...entities.book import Book
from ...entities.user_book import UserBook
from ..model import TokenData
from uuid import UUID
import logging


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

def add_book_to_library(db: Session, book: AddBook, current_user: TokenData) -> Book:
    """Add a book to the books table and to user's library"""
    
    try:
        # Check if book already exists by external_id
        if book.external_id:
            existing_book = db.query(Book).filter_by(external_id=book.external_id).first()
            if existing_book:
                # Book exists, just add to user's library if not already there
                existing_user_book = db.query(UserBook).filter_by(
                    user_id=current_user.get_uuid(),
                    book_id=existing_book.id
                ).first()
                
                if not existing_user_book:
                    user_book = UserBook(
                        user_id=current_user.get_uuid(),
                        book_id=existing_book.id,
                        status='want_to_read'
                    )
                    db.add(user_book)
                    db.commit()
                    logging.info(f"Added existing book {existing_book.id} to user {current_user.get_uuid()} library")
                else:
                    logging.info(f"Book {existing_book.id} already in user {current_user.get_uuid()} library")
                
                return existing_book
        
        # Create new book
        new_book = Book(
            title=book.title,
            author=book.author,
            description=book.description,
            pages=book.pages,
            cover_image=book.cover_image,
            source=book.source,
            external_id=book.external_id,
        )
        
        db.add(new_book)
        db.flush()  # Get the ID without committing
        
        logging.info(f"Created new book {new_book.id} with title: {new_book.title}")
        
        # Add to user's library
        user_book = UserBook(
            user_id=current_user.get_uuid(),
            book_id=new_book.id,
            status='want_to_read'
        )
        db.add(user_book)
        db.commit()  # Commit both together
        
        logging.info(f"Successfully added book {new_book.id} to user {current_user.get_uuid()} library")
        return new_book
    
    except Exception as e:
        logging.error(f"Error adding book to library: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to add book: {str(e)}")


def get_user_library(current_user: TokenData, db: Session) -> List[UserBookResponse]:
    """Get all books in user's library with their status"""
    user_books = db.query(UserBook, Book).join(
        Book, UserBook.book_id == Book.id
    ).filter(
        UserBook.user_id == current_user.get_uuid()
    ).all()
    
    logging.info(f"Retrieved {len(user_books)} books for user library: {current_user.get_uuid()}")
    
    results = []
    for user_book, book in user_books:
        results.append(UserBookResponse(
            id=book.id,
            title=book.title,
            author=book.author,
            cover_image=book.cover_image,
            status=user_book.status,
            progress=user_book.progress,
            added_at=user_book.added_at
        ))
    
    return results


def add_to_user_library(current_user: TokenData, db: Session, book_id: UUID, status: str):
    """Add a book to user's library"""
    # Check if book exists
    book = db.query(Book).filter(Book.id == book_id).first()
    if not book:
        raise HTTPException(status_code=404, detail="Book not found")
    
    # Check if already in library
    existing = db.query(UserBook).filter_by(
        user_id=current_user.get_uuid(),
        book_id=book_id
    ).first()
    
    if existing:
        # Update status if already exists
        existing.status = status
        db.commit()
        logging.info(f"Updated book {book_id} status to {status} for user {current_user.get_uuid()}")
        return {"message": "Book status updated"}
    
    # Add new entry
    user_book = UserBook(
        user_id=current_user.get_uuid(),
        book_id=book_id,
        status=status
    )
    db.add(user_book)
    db.commit()
    logging.info(f"Added book {book_id} to library for user {current_user.get_uuid()}")
    return {"message": "Book added to library"}


def remove_from_user_library(current_user: TokenData, db: Session, book_id: UUID):
    """Remove a book from user's library"""
    user_book = db.query(UserBook).filter_by(
        user_id=current_user.get_uuid(),
        book_id=book_id
    ).first()
    
    if not user_book:
        raise HTTPException(status_code=404, detail="Book not in library")
    
    db.delete(user_book)
    db.commit()
    logging.info(f"Removed book {book_id} from library for user {current_user.get_uuid()}")
    return {"message": "Book removed from library"}