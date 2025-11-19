from fastapi import FastAPI
from .database.core import engine, Base
from .entities.user import User
from .entities.book import Book
from .entities.group import Group
from .entities.group_books import GroupBook
from .entities.group_members import GroupMember
from .entities.disscusion_messages import DiscussionMessages
from .api import register_routes
from .logging import configure_logging, LogLevels

app = FastAPI()

configure_logging(LogLevels)

# Create all tables in the database 
Base.metadata.create_all(bind=engine)

register_routes(app)

