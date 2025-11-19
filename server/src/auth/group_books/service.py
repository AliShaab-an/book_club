from sqlalchemy.orm import Session

from . import model
from ...entities.group_books import GroupBook


def select_book_for_group(data: model.SelectBookRequest,db:Session) -> model.SelectBookRequest:
    existing = db.query(GroupBook).filter_by(group_id= data.group_id,book_id= data.book_id).first()
    if existing:
        return existing
    group_book = GroupBook(
        group_id= data.group_id,
        book_id = data.book_id,
        status = data.status,
    )

    db.add(group_book)
    db.commit()
    db.refresh(group_book)
    return group_book