SET search_path = 't';
      
WITH a AS 
 (
	SELECT date_trunc('week', dt::date) AS start_w , dt, master_id, first_name, EXTRACT(isodow FROM dt) AS day_of_week, 1 AS work_day    
	FROM activity a 
	LEFT JOIN masters m 
	ON m.id = a.master_id 
	WHERE dt >= (SELECT current_date - INTERVAL '4 week')
	GROUP BY start_w , dt, master_id, first_name
	ORDER BY dt
 )
  , b AS 
		(
			SELECT *, sum(work_day) OVER (PARTITION BY start_w, master_id ORDER BY start_w) AS amount_days
			FROM a
		)
SELECT  start_w, 
       master_id, 
       first_name,
       amount_days
FROM b 
WHERE amount_days >= 5
GROUP BY start_w, 
       master_id, 
       first_name,
       amount_days
ORDER BY start_w