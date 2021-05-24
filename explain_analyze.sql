EXPLAIN ANALYZE
WITH villas_dates AS (
SELECT roombooking."roomID", roombooking.checkout, roombooking.checkin, roombooking.rate
FROM (SELECT * FROM room WHERE room.roomtype = 'Villa') as villas
INNER JOIN roombooking ON roombooking."roomID" = villas."idRoom"
WHERE roombooking.checkin BETWEEN date '2021-06-01' AND date '2021-10-01'
	AND roombooking.checkout BETWEEN date '2021-06-01' AND date '2021-10-01'
)
SELECT (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin)))) AS "Month", 
		(SUM(ABS(villas_dates.checkout - villas_dates.checkin) * villas_dates.rate)) AS "Earnings" 
		FROM villas_dates
		GROUP BY (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin))))
		ORDER BY (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin))))

SELECT roombooking."roomID", roombooking.checkin, roombooking.checkout,
	roombooking.rate
FROM (SELECT * FROM room WHERE room.roomtype = 'Villa') as villas
INNER JOIN roombooking ON roombooking."roomID" = villas."idRoom"
WHERE roombooking.checkin BETWEEN date '2021-06-01' AND date '2021-08-01'
	OR roombooking.checkout BETWEEN date '2021-06-01' AND date '2021-08-01'
	
	
SELECT (SELECT EXTRACT(MONTH FROM  roombooking.checkin)) AS "Month", 
		(SUM((roombooking.checkout - roombooking.checkin) * roombooking.rate)) AS "Earnings" 
		FROM roombooking
		GROUP BY (SELECT EXTRACT(MONTH FROM  roombooking.checkin));


SELECT relname, relkind, reltuples
FROM pg_class
WHERE relname LIKE 'room%'


WITH villas_dates AS (
SELECT roombooking."roomID", roombooking.checkout, roombooking.checkin, roombooking.rate
FROM (SELECT * FROM room WHERE room.roomtype = 'Villa') as villas
INNER JOIN roombooking ON roombooking."roomID" = villas."idRoom"
WHERE roombooking.checkin BETWEEN date '2021-06-01' AND date '2021-10-01'
	AND roombooking.checkout BETWEEN date '2021-06-01' AND date '2021-10-01'
)

EXPLAIN ANALYZE
SELECT (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin)))) AS "Month", 
		(SUM(ABS(villas_dates.checkout - villas_dates.checkin) * villas_dates.rate)) AS "Earnings" 
		FROM (SELECT roombooking.checkout, roombooking.checkin, roombooking.rate
			FROM (SELECT * FROM room WHERE room.roomtype = 'Villa') as villas
			INNER JOIN roombooking ON roombooking."roomID" = villas."idRoom"
			WHERE roombooking.checkin BETWEEN date '2021-06-01' AND date '2021-10-01'
	AND roombooking.checkout BETWEEN date '2021-06-01' AND date '2021-10-01') AS villas_dates
		GROUP BY (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin))))
		ORDER BY (SELECT EXTRACT(month FROM (DATE_TRUNC('month',villas_dates.checkin))));
		
CREATE INDEX roombooking_checkin_index ON roombooking USING btree(checkin)
CREATE INDEX roombooking_checkout_index ON roombooking USING btree(checkout)

DROP INDEX roombooking_checkin_index
DROP INDEX roombooking_checkout_index

CLUSTER roombooking USING "fki_bookedforpersonID_FK"

CLUSTER roombooking USING roombooking_checkin_index
