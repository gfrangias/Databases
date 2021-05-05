WITH x AS (
	SELECT idhotelbooking
	FROM hotelbooking
	ORDER BY RANDOM() LIMIT 2000
    FOR UPDATE
)
UPDATE hotelbooking
SET payed = TRUE 
WHERE hotelbooking.idhotelbooking IN (SELECT idhotelbooking from x)
