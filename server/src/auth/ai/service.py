import os
from typing import List, Dict
import logging

try:
    import httpx
except ImportError:
    logging.error("httpx not installed. Run: pip install httpx")
    raise

from dotenv import load_dotenv

load_dotenv()

OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'

if not OPENAI_API_KEY:
    logging.error("OPENAI_API_KEY not found in environment variables!")
else:
    logging.info("OpenAI API Key loaded successfully")


async def call_openai(
    messages: List[Dict[str, str]],
    temperature: float = 0.7,
    max_tokens: int = 500
) -> str:
    """Call OpenAI API and return the response"""
    
    try:
        async with httpx.AsyncClient() as client:
            logging.info(f"Calling OpenAI API with {len(messages)} messages")
            response = await client.post(
                OPENAI_API_URL,
                headers={
                    'Content-Type': 'application/json',
                    'Authorization': f'Bearer {OPENAI_API_KEY}',
                },
                json={
                    'model': 'gpt-3.5-turbo',
                    'messages': messages,
                    'temperature': temperature,
                    'max_tokens': max_tokens,
                },
                timeout=30.0
            )
            
            logging.info(f"OpenAI API response status: {response.status_code}")
            
            if response.status_code == 200:
                data = response.json()
                return data['choices'][0]['message']['content'].strip()
            else:
                error_data = response.json()
                error_message = error_data.get('error', {}).get('message', 'Unknown error')
                logging.error(f"OpenAI API error: {error_message}")
                raise Exception(f'OpenAI API error: {error_message}')
    except httpx.RequestError as e:
        logging.error(f"Network error calling OpenAI: {str(e)}")
        raise Exception(f"Network error: {str(e)}")
    except Exception as e:
        logging.error(f"Error in call_openai: {str(e)}")
        raise


async def send_chat_message(
    message: str,
    conversation_history: List[Dict[str, str]],
    book_title: str = None,
    book_context: str = None
) -> str:
    """Send a chat message to OpenAI with conversation history"""
    
    # Build system prompt
    system_prompt = (
        'You are a helpful AI reading assistant for a book club app. '
        'Help users with book recommendations, summaries, discussion questions, '
        'and literary analysis. Be concise, engaging, and insightful.'
    )
    
    if book_title:
        system_prompt += f' The user is currently discussing "{book_title}".'
    
    if book_context:
        system_prompt += f' Context: {book_context}'
    
    # Build messages array
    messages = [
        {'role': 'system', 'content': system_prompt},
        *conversation_history,
        {'role': 'user', 'content': message},
    ]
    
    return await call_openai(messages)


async def get_book_recommendations(book_title: str, count: int = 5) -> List[str]:
    """Get book recommendations based on a given book"""
    
    prompt = (
        f'Based on the book "{book_title}", recommend {count} similar books. '
        f'Return only the book titles, one per line, without numbering or extra text.'
    )
    
    messages = [
        {'role': 'system', 'content': 'You are a book recommendation expert.'},
        {'role': 'user', 'content': prompt},
    ]
    
    response = await call_openai(messages, max_tokens=300)
    
    # Parse response into list
    recommendations = [
        line.strip() 
        for line in response.split('\n') 
        if line.strip()
    ]
    
    return recommendations[:count]


async def generate_book_summary(book_title: str) -> str:
    """Generate a book summary"""
    
    prompt = (
        f'Provide a concise summary of the book "{book_title}" in 2-3 paragraphs. '
        f'Include the main themes and key plot points without major spoilers.'
    )
    
    messages = [
        {'role': 'system', 'content': 'You are a literary analyst.'},
        {'role': 'user', 'content': prompt},
    ]
    
    return await call_openai(messages, max_tokens=600)


async def generate_discussion_questions(book_title: str, count: int = 5) -> List[str]:
    """Generate discussion questions for a book"""
    
    prompt = (
        f'Generate {count} thoughtful discussion questions for the book "{book_title}". '
        f'Format each question on a new line, numbered.'
    )
    
    messages = [
        {'role': 'system', 'content': 'You are a book club facilitator.'},
        {'role': 'user', 'content': prompt},
    ]
    
    response = await call_openai(messages, max_tokens=400)
    
    # Parse response into list
    questions = [
        line.strip() 
        for line in response.split('\n') 
        if line.strip()
    ]
    
    return questions
