CREATE FUNCTION client_roombookings(client_id integer, hotel_id integer)
RETURNS TABLE (Room_ID integer, Checkin date, Checkout date, Rate real)
AS
$$ 
BEGIN

RETURN QUERY
SELECT room."idRoom", roombooking.checkin, roombooking.checkout, roombooking.rate
FROM (SELECT * FROM client WHERE client."idClient" = client_id) as cl
INNER JOIN hotelbooking ON hotelbooking."bookedbyclientID" = cl."idClient"
INNER JOIN roombooking ON roombooking."hotelbookingID" = hotelbooking.idhotelbooking
INNER JOIN room ON room."idRoom" = roombooking."roomID"
WHERE room."idHotel" = hotel_id 
ORDER BY roombooking."hotelbookingID" ASC;

END;
$$
LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM client_roombookings('41','11');

