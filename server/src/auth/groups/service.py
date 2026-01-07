from uuid import uuid4, UUID
from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from . import model

from ...entities.group import Group
from ...entities.group_members import GroupMember
from ...entities.group_books import GroupBook
from ...entities.book import Book
from src.exceptions import GroupCreationError, GroupNotFoundError
import logging

from ..model import TokenData

def create_group(current_user: TokenData,db:Session, group:model.CreateGroup) -> Group:
    try:
        new_group = Group(**group.model_dump())
        new_group.user_id = current_user.get_uuid()
        db.add(new_group)
        db.commit()
        db.refresh(new_group)
        logging.info(f"Created new group for user: {new_group.user_id}")
        return new_group
    except Exception as e:
        logging.error(f"failed to create group for user: {current_user.get_uuid()}. Error: {str(e)}")
        raise GroupCreationError(str(e))

def get_groups(current_user: TokenData, db: Session) -> list[model.GroupResponse]:
    # Query groups with their associated books
    results = db.query(
        Group,
        Book.id.label('book_id'),
        Book.title.label('book_title'),
        Book.cover_image.label('book_cover_url')
    ).outerjoin(
        GroupBook, Group.id == GroupBook.group_id
    ).outerjoin(
        Book, GroupBook.book_id == Book.id
    ).filter(
        Group.user_id == current_user.get_uuid()
    ).all()
    
    logging.info(f"Retrieved {len(results)} groups for user: {current_user.get_uuid()}")
    
    # Build response with book information
    groups = []
    for group, book_id, book_title, book_cover_url in results:
        group_dict = {
            'id': group.id,
            'name': group.name,
            'description': group.description,
            'user_id': group.user_id,
            'created_at': group.created_at,
            'book_id': book_id,
            'book_title': book_title,
            'book_cover_url': book_cover_url
        }
        groups.append(model.GroupResponse(**group_dict))
    
    return groups

def search_groups(current_user: TokenData, db: Session, query: str) -> list[model.GroupResponse]:
    groups = db.query(Group).filter(
        Group.name.ilike(f"%{query}%") | Group.description.ilike(f"%{query}%")
    ).all()
    logging.info(f"Found {len(groups)} groups matching query: {query}")
    return groups

def get_group_by_id(current_user:TokenData,db:Session,group_id:UUID) -> Group:
    group = db.query(Group).filter(Group.id == group_id).filter(Group.user_id == current_user.get_uuid()).first()

    if not group:
        logging.warning(f"Group {group_id} not fount for user {current_user.get_uuid()}")
        raise GroupNotFoundError(group_id)
    logging.info(f"Retrieved todo {group_id} for user {current_user.get_uuid()}")
    return group


"""fix this function todo-related errors"""
def join_group(current_user:TokenData,db:Session,group_id:UUID):
    existing = db.query(GroupMember).filter_by(user_id =current_user.get_uuid(),group_id= group_id).first()

    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User already a member of the group.")

    member = GroupMember(user_id = current_user.user_id,group_id= group_id)

    db.add(member)
    db.commit()
    db.refresh(member)
    logging.info(f"Created new group for user: {current_user.get_uuid()}")
    return member

def update_group(current_user:TokenData,db:Session,group_id:UUID,group_update:model.CreateGroup) -> Group:
    group_data = group_update.model_dump(exclude_unset=True)
    db.query(Group).filter(Group.id == group_id).filter(Group.user_id == current_user.get_uuid()).update(group_data)
    db.commit()
    logging.info(f"Successfully updated todo {group_id} for user {current_user.get_uuid()}")
    return get_group_by_id(current_user,db,group_id)


def delete_group(current_user:TokenData,db:Session,group_id:UUID) -> None:
    group = get_group_by_id(current_user,db,group_id)
    db.delete(group)
    db.commit()
    logging.info(f"Todo {group_id} deleted by user {current_user.get_uuid()}")
