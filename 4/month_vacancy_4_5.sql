CREATE FUNCTION month_vacancy_4_5(hotel_id integer, year integer)
RETURNS TABLE("Month" text, "Vacancy" bigint) AS
$$
DECLARE
	num_of_rooms integer;

BEGIN

--Check if the temporary table 'roombookings' already exists
IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'roombookings') THEN
	DROP TABLE roombookings;
END IF;

--Create temporary table 'roombookings'
CREATE TEMP TABLE roombookings(room_ID integer, checkin_date date, checkout_date date);

--Compute the number of rooms of this hotel
num_of_rooms = count(*)
FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) as rooms
INNER JOIN roombooking AS roombookings ON roombookings."roomID" = rooms."idRoom";

RETURN QUERY
-- Insert all room bookings of this hotel in the temporary table 'roombookings'
WITH roombookings AS(
SELECT roombookings."roomID", roombookings.checkin, roombookings.checkout
FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) as rooms
INNER JOIN roombooking AS roombookings ON roombookings."roomID" = rooms."idRoom")
--Compute the vacancy percentage for every month of this year
SELECT (SELECT double_to_month(EXTRACT(month FROM (DATE_TRUNC('month',roombookings.checkin))))) AS "Month",
			count(roombookings."roomID")*'100'/num_of_rooms AS "Vacancy"
			FROM roombookings
			WHERE
			(EXTRACT(year FROM roombookings.checkin) = year OR
			EXTRACT(year FROM roombookings.checkout) = year)
			GROUP BY (SELECT double_to_month(EXTRACT(month FROM (DATE_TRUNC('month',roombookings.checkin)))));
END
$$
LANGUAGE 'plpgsql';

--SELECT * FROM month_vacancy_4_5('52', '2021')