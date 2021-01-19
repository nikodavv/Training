
SET search_path = 't';

WITH masters AS 
(
SELECT DISTINCT dt, master_id, min(dt) OVER (PARTITION BY master_id) AS master_date
FROM activity a 
)
SELECT DISTINCT dt, count(CASE WHEN dt  - INTERVAL '90' day >= master_date THEN 'old_master' end)
                    OVER  (PARTITION BY dt ) AS old_masters,
                    count(CASE WHEN dt - INTERVAL '14 days' > master_date   
                                    AND dt - INTERVAL '90 days' < master_date THEN 'mid_master' end)
                    OVER  (PARTITION BY dt) AS mid_masters,
                    count(CASE WHEN dt - INTERVAL '14 days'<= master_date THEN 'new_master' END)
                    OVER  (PARTITION BY dt) AS new_masters
FROM masters
ORDER BY dt; 

