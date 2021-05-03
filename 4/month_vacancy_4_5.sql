CREATE FUNCTION month_vacancy_4_5(hotel_id integer, year integer)
RETURNS TABLE("Month" double precision, "Vacancy" bigint) AS
$$
DECLARE
	num_of_rooms integer;

BEGIN

IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'roombookings') THEN
	DROP TABLE roombookings;
END IF;

CREATE TEMP TABLE roombookings(room_ID integer, checkin_date date, checkout_date date);

num_of_rooms = count(*)
FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) as rooms
INNER JOIN roombooking AS roombookings ON roombookings."roomID" = rooms."idRoom";

INSERT INTO roombookings(room_ID, checkin_date, checkout_date) 
SELECT roombookings."roomID", roombookings.checkin, roombookings.checkout
FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) as rooms
INNER JOIN roombooking AS roombookings ON roombookings."roomID" = rooms."idRoom"; 

RETURN QUERY
SELECT EXTRACT(month FROM (DATE_TRUNC('month',roombookings.checkin_date))) AS "Month",
			count(roombookings.room_id)*'100'/num_of_rooms AS "Vacancy"
			FROM roombookings
			WHERE
			(EXTRACT(year FROM roombookings.checkin_date) = year OR
			EXTRACT(year FROM roombookings.checkout_date) = year)
			GROUP BY EXTRACT(month FROM (DATE_TRUNC('month',roombookings.checkin_date)));
END
$$
LANGUAGE 'plpgsql';

--SELECT * FROM month_vacancy_4_5('11', '2021')