-- Sample data for clubs
-- First, get your user ID:
-- SELECT id FROM users WHERE email = 'test.user@gmail.com';

-- Copy the user ID from the result above and paste it below replacing 'YOUR_USER_ID_HERE'
-- Then run these INSERT statements:

INSERT INTO "group" (id, name, description, 4a9ea6a4-0ba1-4739-8930-0a1fb4a8d2b7, created_at)
VALUES 
  (gen_random_uuid(), 'The Great Gatsby Club', 'A club dedicated to discussing F. Scott Fitzgerald''s masterpiece and the Jazz Age', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), '1984 Discussion Group', 'Exploring Orwell''s dystopian vision and its relevance in today''s world', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Harry Potter Fans', 'Magic, friendship, and adventure - join us in the wizarding world!', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Classic Literature Society', 'Reading and discussing timeless literary works from around the world', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Sci-Fi Explorers', 'Dive into worlds of science fiction and imagination', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Mystery Book Club', 'Solving mysteries one book at a time - thrillers, detectives, and whodunits', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Romance Readers United', 'Love stories that capture our hearts and warm our souls', 'YOUR_USER_ID_HERE', NOW()),
  (gen_random_uuid(), 'Non-Fiction Knowledge Hub', 'Expand your mind with real-world insights, biographies, and more', 'YOUR_USER_ID_HERE', NOW());
