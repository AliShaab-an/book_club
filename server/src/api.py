from fastapi import FastAPI
from src.auth.controller import router as auth_router
from src.auth.users.controller import router as users_router
from src.auth.groups.controller import router as groups_router
from src.auth.book.controller import router as book_router
from src.auth.group_books.controller import router as groupBooks_router
from src.auth.chat.controller import router as chat_router

def register_routes(app: FastAPI):
    app.include_router(auth_router)
    app.include_router(users_router)
    app.include_router(groups_router)
    app.include_router(book_router)
    app.include_router(groupBooks_router)
    app.include_router(chat_router)