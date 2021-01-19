SET search_path = 't';

      

WITH g AS
(
SELECT DISTINCT dt, master_id, section_id, min(dt) OVER (PARTITION BY master_id) AS master_date
FROM activity a 
),
selecting AS 
(
SELECT *, count(CASE WHEN dt  - INTERVAL '90' day >= master_date THEN 'old_master' end)
                            OVER (PARTITION BY dt, section_id ORDER BY dt, section_id )  AS old_masters                       
FROM g
), b AS (
    SELECT dt, section_id, max(old_masters) AS amount
    FROM selecting e
    GROUP BY dt, section_id, old_masters
    HAVING max(old_masters) >0
    ORDER BY 1 ASC, 3 desc , 2 asc )
   ,c AS 
      (
       SELECT *, ROW_NUMBER () OVER (PARTITION BY dt) AS n
       FROM b 
      )
       SELECT dt, section_id 
       FROM c
       WHERE n = 1;      
       
      
      
      
