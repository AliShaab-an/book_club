import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)

# SQL to add new columns to books table
migration_sql = """
ALTER TABLE books ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users(id);
ALTER TABLE books ADD COLUMN IF NOT EXISTS status VARCHAR(50);
ALTER TABLE books ADD COLUMN IF NOT EXISTS progress INTEGER;
ALTER TABLE books ADD COLUMN IF NOT EXISTS added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
CREATE INDEX IF NOT EXISTS idx_books_user_id ON books(user_id);
"""

print("Running migration to add columns to books table...")
try:
    with engine.connect() as conn:
        conn.execute(text(migration_sql))
        conn.commit()
        print("✓ Migration completed successfully!")
        
        # Verify the changes
        print("\nBooks table structure:")
        result = conn.execute(text("SELECT column_name, data_type FROM information_schema.columns WHERE table_name='books' ORDER BY ordinal_position"))
        for row in result:
            print(f"  - {row[0]}: {row[1]}")
except Exception as e:
    print(f"✗ Migration failed: {e}")
