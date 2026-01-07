from fastapi import APIRouter, HTTPException, status
from . import model, service
from ..service import CurrentUser
import logging
import traceback

router = APIRouter(
    prefix='/ai',
    tags=['AI Assistant']
)


@router.post('/chat', response_model=model.ChatResponse)
async def chat(request: model.ChatRequest, current_user: CurrentUser):
    """Send a chat message to AI assistant"""
    try:
        logging.info(f"===== AI CHAT REQUEST =====")
        logging.info(f"User ID: {current_user.get_uuid()}")
        logging.info(f"Message: {request.message[:50] if request.message else 'None'}...")
        logging.info(f"Book title: {request.book_title}")
        logging.info(f"History length: {len(request.conversation_history)}")
        
        # Convert ChatMessage objects to dict
        conversation_history = [
            {'role': msg.role, 'content': msg.content}
            for msg in request.conversation_history
        ]
        
        response = await service.send_chat_message(
            message=request.message,
            conversation_history=conversation_history,
            book_title=request.book_title,
            book_context=request.book_context
        )
        
        logging.info(f"AI chat successful for user: {current_user.get_uuid()}")
        logging.info(f"Response length: {len(response)} characters")
        return model.ChatResponse(response=response)
        
    except Exception as e:
        logging.error(f"===== AI CHAT ERROR =====")
        logging.error(f"User: {current_user.get_uuid() if current_user else 'Unknown'}")
        logging.error(f"Error: {str(e)}")
        logging.error(f"Traceback: {traceback.format_exc()}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"AI service error: {str(e)}"
        )


@router.post('/recommendations', response_model=model.BookRecommendationResponse)
async def get_recommendations(
    request: model.BookRecommendationRequest,
    current_user: CurrentUser
):
    """Get book recommendations"""
    try:
        recommendations = await service.get_book_recommendations(
            book_title=request.book_title,
            count=request.count
        )
        
        logging.info(
            f"Generated {len(recommendations)} recommendations for user: {current_user.get_uuid()}"
        )
        return model.BookRecommendationResponse(recommendations=recommendations)
        
    except Exception as e:
        logging.error(f"Recommendation error for user {current_user.get_uuid()}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"AI service error: {str(e)}"
        )


@router.post('/summary', response_model=model.BookSummaryResponse)
async def get_summary(request: model.BookSummaryRequest, current_user: CurrentUser):
    """Generate book summary"""
    try:
        summary = await service.generate_book_summary(
            book_title=request.book_title
        )
        
        logging.info(f"Generated summary for user: {current_user.get_uuid()}")
        return model.BookSummaryResponse(summary=summary)
        
    except Exception as e:
        logging.error(f"Summary error for user {current_user.get_uuid()}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"AI service error: {str(e)}"
        )


@router.post('/discussion-questions', response_model=model.DiscussionQuestionsResponse)
async def get_discussion_questions(
    request: model.DiscussionQuestionsRequest,
    current_user: CurrentUser
):
    """Generate discussion questions"""
    try:
        questions = await service.generate_discussion_questions(
            book_title=request.book_title,
            count=request.count
        )
        
        logging.info(
            f"Generated {len(questions)} questions for user: {current_user.get_uuid()}"
        )
        return model.DiscussionQuestionsResponse(questions=questions)
        
    except Exception as e:
        logging.error(f"Questions error for user {current_user.get_uuid()}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"AI service error: {str(e)}"
        )
