from src.database.core import engine
from sqlalchemy import inspect

inspector = inspect(engine)
columns = inspector.get_columns('books')

print('Books table columns:')
for col in columns:
    print(f"- {col['name']}: {col['type']}")
