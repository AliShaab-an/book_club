from fastapi import FastAPI
from .database.core import engine, Base
from .entities.user import User
from .entities.book import Book
from .entities.user_book import UserBook
from .entities.group import Group
from .entities.group_books import GroupBook
from .entities.group_members import GroupMember
from .entities.disscusion_messages import DiscussionMessages
from .api import register_routes
from .logging import configure_logging, LogLevels
import os
app = FastAPI()

configure_logging(LogLevels)
# print("DATABASE_URL USED:", os.getenv("DATABASE_URL"))
# print("Registered tables:", list(Base.metadata.tables.keys()))
Base.metadata.create_all(bind=engine)

register_routes(app)

