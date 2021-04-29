CREATE FUNCTION search_participants_4_1(hotel_id integer)
RETURNS TABLE(clientID integer, partipations bigint) 
AS
$$
BEGIN
RETURN QUERY
SELECT hb."bookedbyclientID", CASE WHEN part."idPerson" IS NULL THEN '0'
							  WHEN part."idPerson" IS NOT NULL THEN count(*)
							  END partitipations
FROM (SELECT * FROM participates WHERE participates.idhotel = hotel_id) as part
RIGHT JOIN (SELECT DISTINCT hotelbooking."bookedbyclientID"
							FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) AS r
							INNER JOIN roombooking ON roombooking."roomID" = r."idRoom"
							INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID") AS hb 
			ON hb."bookedbyclientID" = part."idPerson"
GROUP BY hb."bookedbyclientID", part."idPerson";
END;
$$ 
LANGUAGE 'plpgsql' STABLE;

SELECT * FROM search_participants_4_1('53')

