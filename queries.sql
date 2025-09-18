-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Register a new user
-- This query will be executed in sign-up form
INSERT INTO "users" ("name", "email", "password_hash")
VALUES ('fake_name', 'fake@email.com', 'fake_hashed_password');

-- Find a user by email 
-- This step is common during login to verify user credentials
SELECT "id", "name", "password_hash" FROM "users"
WHERE "email" = 'fake@email.com';

-- Update a user’s name
-- this might be used in a profile settings page
UPDATE "users" SET "name" = 'new_fake_name'
WHERE "id" = 1;

-- Delete a user
-- In settings page, if the user wants to delete their account,
-- they also will delete all data associated with that user,
-- their snippets will be deleted and their comments will still 
-- be visible but with anonymous author
DELETE FROM "users"
WHERE "id" = 1;

-- Create a new public snippet
-- In community section, users can create their public snippets
-- that will be visible to all users
INSERT INTO "snippets" ("title", "description", "code", "visibility", "user_id", "language_id")
VALUES (
  'Hello World in Python',
  'Simple Python hello world example',
  $$print("Hello, world!")$$,
  'public',
  2, -- user_id     --> snippet author
  1  -- language_id --> snippet language
);

-- Get all public snippets (for feed or search)
-- This is executed when users go to community section
SELECT "snips"."id", "snips"."title", "snips"."description", "snips"."created_at", 
    "usrs"."name", "lang"."name" AS "language"
FROM "snippets" AS "snips"
JOIN "users" AS "usrs" ON "snips"."user_id" = "usrs"."id"
JOIN "languages" AS "lang" ON "snips"."language_id" = "lang"."id"
WHERE "snips"."visibility" = 'public'
ORDER BY "snips"."created_at" DESC;

-- Search snippets by title
-- If users want to search snippets by snippet title
SELECT "id", "title", "description" FROM "snippets"
WHERE "title" LIKE '%API%';

-- Get all snippets created by a specific user
-- If users want to search snippets by snippet author
-- Snippets ordered by creation date (newest first)
SELECT "id", "title", "visibility", "created_at" FROM "snippets"
WHERE "user_id" = 3
ORDER BY "created_at" DESC;

-- Delete a snippet
-- This also deletes its likes and its comments
DELETE FROM "snippets"
WHERE "id" = 10;

-- Like a snippet
INSERT INTO "likes" ("user_id", "snippet_id") VALUES (2, 5);

-- Count likes for a snippet
-- When user enters a snippet page to see its details
SELECT COUNT(*) AS "total_likes" FROM "likes"
WHERE "snippet_id" = 5;

-- Get snippets liked by a user
-- In user profile, a section to see snippets user liked
SELECT "snip"."id", "snip"."title", "snip"."description"
FROM "likes"
JOIN "snippets" AS "snip" ON "likes"."snippet_id" = "snip"."id"
WHERE "likes"."user_id" = 2;

-- Unlike a snippet
DELETE FROM "likes"
WHERE "user_id" = 2 AND "snippet_id" = 5;

-- Add a comment to a snippet
INSERT INTO "comments" ("user_id", "snippet_id", "content")
VALUES (3, 5, 'Great example! Thanks for sharing.');

-- Get comments for a snippet (with name of commenter)
-- When user enters a snippet page to see its details
-- Comments are ordered by creation date (newest first)
SELECT "comm"."id", "comm"."content", "comm"."created_at", "usrs"."name"
FROM "comments" AS "comm"
JOIN "users" AS "usrs" ON "comm"."user_id" = "usrs"."id"
WHERE "comm"."snippet_id" = 5
ORDER BY "comm"."created_at" DESC;

-- Delete a comment
-- Only the author is allowed to delete their comments
DELETE FROM "comments"
WHERE "id" = 30 AND "user_id" = 3;