CREATE FUNCTION greater_earnings_4_4()
RETURNS TABLE(idhotel integer, city character varying(45), earnings double precision)
AS
$$
DECLARE
	average real;
BEGIN
average = AVG(rr.sum)
FROM (SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr;

RETURN QUERY
SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel",
hotel.city, rr.sum															
FROM hotel
INNER JOIN
(SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr ON rr."idHotel" = hotel."idHotel"
WHERE rr.sum > average
GROUP BY hotel."idHotel", rr.sum;

END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM greater_earnings_4_4();