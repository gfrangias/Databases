CREATE FUNCTION greater_earnings_4_4()
RETURNS TABLE(idhotel integer, city character varying(45), earnings double precision)
AS
$$
DECLARE
	average real;
BEGIN

--Compute the average of the earnings
average = AVG(rr.sum)
--Compute the earnings of all of the hotels
FROM (SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr;


RETURN QUERY
--Return all the hotel IDs, cities and earnings
SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel",
hotel.city, rr.sum															
FROM hotel

--Compute the earnings of this hotel
INNER JOIN
(SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr ON rr."idHotel" = hotel."idHotel"

--Display only if the earnings are higher than the average earnings of a hotel
WHERE rr.sum > average
GROUP BY hotel."idHotel", rr.sum;

END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM greater_earnings_4_4();