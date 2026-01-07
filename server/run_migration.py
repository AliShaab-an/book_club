from src.database.core import engine

# SQL to add new columns to books table
migration_sql = """
-- Add new columns to books table for user library functionality
ALTER TABLE books ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users(id);
ALTER TABLE books ADD COLUMN IF NOT EXISTS status VARCHAR(50);
ALTER TABLE books ADD COLUMN IF NOT EXISTS progress INTEGER;
ALTER TABLE books ADD COLUMN IF NOT EXISTS added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Create an index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_books_user_id ON books(user_id);
"""

print("Running migration...")
with engine.connect() as conn:
    conn.execute(migration_sql)
    conn.commit()
    print("Migration completed successfully!")
    
# Verify the changes
print("\nVerifying books table structure...")
result = conn.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name='books' ORDER BY ordinal_position")
for row in result:
    print(f"  - {row[0]}: {row[1]}")
