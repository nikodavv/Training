

WITH newd AS (
  SELECT 'Others' :: text AS object_namespace,
         object_type,
         sum(cnt) AS total_number,
         max(longest_name) AS longest_name_length,
         now() AS updated_datetime,
         'Student'::text AS updated_by
  FROM hr.new_data
  GROUP BY object_type
 ), 
updating AS (
UPDATE hr.my_objects obj
  SET object_type = wd.object_type, 
  object_namespace= cast('HR and Others' AS text),
  total_number = wd.total_number + obj.total_number,
  longest_name_length = GREATEST (wd.longest_name_length, obj.longest_name_length),
  updated_datetime = now(),
  updated_by = wd.updated_by
  FROM newd wd
  WHERE obj.object_type = wd.object_type 
  RETURNING obj.* )
INSERT INTO hr.my_objects
SELECT * FROM newd AS nd
WHERE nd.object_type NOT IN (SELECT object_type FROM updating)
RETURNING *;





