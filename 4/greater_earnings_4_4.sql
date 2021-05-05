CREATE FUNCTION greater_earnings_4_4()
RETURNS TABLE(idhotel integer, city character varying(45), earnings real)
AS
$$
DECLARE
	average real;
BEGIN

--Compute the average of the earnings
average = AVG(earnings.sum)
FROM (
	SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel", SUM("transaction".amount)
	FROM hotel 
	INNER JOIN room ON room."idHotel" = hotel."idHotel"
	INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
	INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID"
	INNER JOIN "transaction" ON "transaction".idhotelbooking = hotelbooking.idhotelbooking
	GROUP BY hotel."idHotel"
	) AS earnings;


RETURN QUERY
--Return all the hotel IDs, cities and earnings
SELECT earnings."idHotel", earnings.city, earnings.sum
FROM (
	SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel", hotel.city, SUM("transaction".amount)
	FROM hotel 
	INNER JOIN room ON room."idHotel" = hotel."idHotel"
	INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
	INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID"
	INNER JOIN "transaction" ON "transaction".idhotelbooking = hotelbooking.idhotelbooking
	GROUP BY hotel."idHotel"
	) AS earnings
	WHERE earnings.sum > average;
END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM greater_earnings_4_4();