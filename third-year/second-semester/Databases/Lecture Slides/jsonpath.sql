-- This file is intended to test Postgres JSON Path 
-- Write your JSON data in the WITH clause, 
--   and your path below (see examples)
-- Then run this file in psql (or copy/paste the contents)
-- This works in recent Postgres verions (12 or later)

-- Note that this isn't typically how you would use paths in
--   Postgres, then you would have JSON in tables - this is 
--   just a test setup. 

WITH Jsondata AS (SELECT '
{"name": "/", "contents": [
  {"name": "file1", "filetype": "txt", "size": 100},
  {"name": "a/", "contents": [
   {"name": "file2", "filetype": "jpg", "size": 200},
   {"name": "file3", "filetype": "mp4", "size": 600},
   {"name": "file4", "filetype": "png", "size": 300}]},
   {"name": "b/", "contents": [
    {"name": "c/", "contents": [
     {"name": "file5", "filetype": "jpg", "size": 400}]}]}]}


    ' :: JSONB AS jsoncolumn)

-- You could use jsonb_path_query_array instead
SELECT jsonb_path_query(jsoncolumn, 
    -- 'strict $.**'
    --'strict $.**?(@.size>200).name'
    '$.contents.*.name'
  ) 
  FROM Jsondata;