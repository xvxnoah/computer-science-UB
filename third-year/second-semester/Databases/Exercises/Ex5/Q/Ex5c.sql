-- This file is intended to test Postgres JSON Path 
-- Write your JSON data in the WITH clause, 
--   and your path below (see examples)
-- Then run this file in psql (or copy/paste the contents)
-- This works in recent Postgres verions (12 or later)

-- Note that this isn't typically how you would use paths in
--   Postgres, then you would have JSON in tables - this is 
--   just a test setup. 
WITH Jsondata AS (SELECT '
{

}
    ' :: JSONB AS jsondata)

SELECT jsonb_path_query(jsondata, -- You could use jsonb_path_query_array instead
    'strict $.**'
  ) 
  FROM Jsondata;