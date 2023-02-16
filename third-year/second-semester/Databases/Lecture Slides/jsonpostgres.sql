
-- Cleaning up from previous runs
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Posts CASCADE;

-- Set up some test data
CREATE TABLE Users( uname TEXT PRIMARY KEY, email TEXT UNIQUE );

CREATE TABLE Posts(
  id SERIAL PRIMARY KEY, 
  author TEXT NOT NULL REFERENCES Users(uname),
  created TIMESTAMP NOT NULL,
  content JSONB NOT NULL
);

INSERT INTO Users VALUES ('Jonas', 'jonas.duregard@chalmers.se');

INSERT INTO Posts VALUES (
    DEFAULT, 
    'Jonas', 
    CURRENT_TIMESTAMP,
    '{"link" : "https://xkcd.com/327/", "preview":true}' :: JSONB
  );

INSERT INTO Posts VALUES (
    DEFAULT, 
    'Jonas', 
    CURRENT_TIMESTAMP,
    '{"picture" : "funnycat.gif", "prop":{"size":15434}}' :: JSONB
  );

-- Just check that it works
SELECT * FROM Posts;

-- Gives null for rows that have no link property
SELECT id, content -> 'link' AS url FROM Posts;

-- One way of finding all pictures
SELECT id, content FROM Posts 
  WHERE content->'picture' IS NOT NULL;

-- Another way of finding all pictures
SELECT * FROM Posts 
  WHERE content ? 'picture';

-- Find all posts with enabled preview
SELECT * FROM Posts 
  WHERE (content->'preview') = 'true';

-- Another way of also finding all posts with enabled previews
SELECT * FROM Posts 
  WHERE (content->'preview') :: BOOLEAN ;

-- Select all post sizes as JSONB documents
SELECT id, content, content->'prop'->'size' AS postsize FROM Posts;

-- Select all post ids and sizes as JSONB documents
-- substitutes 0 if missing
-- converts the resulting document to a number.
-- Will give an error if content.prop.size is not a JSON number
SELECT 
   id, 
   COALESCE(content->'prop'->'size','0') :: NUMERIC AS postsize 
  FROM Posts;


-- **************************************
-- Building JSON documents using Postgres
-- **************************************

-- Add some more test data
INSERT INTO Users VALUES ('sanoJ', 'sanoj.dragerud@chalmers.se');
INSERT INTO Users VALUES ('Nobody', 'nobody@example.com');

INSERT INTO Posts VALUES (
    DEFAULT, 
    'sanoJ', 
    CURRENT_TIMESTAMP,
    '{"link" : "https://example.com/", "preview":false}' :: JSONB
  );


-- Use jsonb_build_object to build a little object for each user
-- Turns the non-JSON data in the tables into JSON
SELECT id, jsonb_build_object(
               'postid',id,
               'user',author
               ) AS jsondata
  FROM Posts;

-- A silly example of using jsonb_build_array
SELECT id, jsonb_build_array(id, author) 
  FROM Posts;

-- Aggregate the authors of all posts into a JSON array
SELECT jsonb_agg(author) AS jsonarray
  FROM Posts;

-- Groups together posts of all users into JSON arrays
SELECT author, jsonb_agg(jsonb_build_object(
                     'postid',id,
                     'user',author)) AS jsondata
  FROM Posts
  GROUP BY Author;

-- Build a JSON document with all info on all users including a list of posts
-- The list is constructed using a correlated query
-- Coalesce is used to replace SQL null values for users with no posts with JSON empty arrays

SELECT jsonb_build_object(
         'uid', uname,
         'email', email,
         'posts', (SELECT coalesce(jsonb_agg(jsonb_build_object(
              'postid',id,
              'time',created)
             ),'[]') FROM Posts WHERE author = U.uname)
       ) AS user_data
  FROM Users U;

