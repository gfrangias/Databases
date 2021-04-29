CREATE FUNCTION search_bookings_3_4(hotel_id integer)
RETURNS TABLE(idHotelbooking integer, clientFname character varying(45), clientLname character varying(45),
			  reservationdate date, bookedBy text)
AS
$$
BEGIN
RETURN QUERY
SELECT DISTINCT roombooking."hotelbookingID", person.fname, person.lname, 
hotelbooking.reservationdate,
CASE 
	WHEN EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'employee'
	WHEN NOT EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'client'
END bookedBy
FROM room
INNER JOIN roombooking ON room."idHotel" = hotel_id
INNER JOIN hotelbooking ON roombooking."hotelbookingID" = hotelbooking.idhotelbooking
INNER JOIN person ON hotelbooking."bookedbyclientID" = person."idPerson";
END; 
$$ LANGUAGE 'plpgsql' STABLE;

SELECT * FROM search_bookings_3_4('89')