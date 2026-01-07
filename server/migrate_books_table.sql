-- Add new columns to books table for user library functionality
ALTER TABLE books ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES users(id);
ALTER TABLE books ADD COLUMN IF NOT EXISTS status VARCHAR(50);
ALTER TABLE books ADD COLUMN IF NOT EXISTS progress INTEGER;
ALTER TABLE books ADD COLUMN IF NOT EXISTS added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Create an index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_books_user_id ON books(user_id);
