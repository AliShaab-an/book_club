-- Drop existing tables (CASCADE will also drop foreign key references)
DROP TABLE IF EXISTS user_books CASCADE;
DROP TABLE IF EXISTS books CASCADE;

-- This will be handled by SQLAlchemy Base.metadata.create_all()
-- Just restart the backend server after running this script
