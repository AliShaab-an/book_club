from typing import Optional, List
from pydantic import BaseModel


class ChatMessage(BaseModel):
    role: str  # 'user' or 'assistant'
    content: str


class ChatRequest(BaseModel):
    message: str
    conversation_history: List[ChatMessage] = []
    book_title: Optional[str] = None
    book_context: Optional[str] = None


class ChatResponse(BaseModel):
    response: str
    error: Optional[str] = None


class BookRecommendationRequest(BaseModel):
    book_title: str
    count: int = 5


class BookRecommendationResponse(BaseModel):
    recommendations: List[str]


class BookSummaryRequest(BaseModel):
    book_title: str


class BookSummaryResponse(BaseModel):
    summary: str


class DiscussionQuestionsRequest(BaseModel):
    book_title: str
    count: int = 5


class DiscussionQuestionsResponse(BaseModel):
    questions: List[str]
