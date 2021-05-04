CREATE FUNCTION search_bookings_3_4(hotel_id integer)
RETURNS TABLE(idHotelbooking integer, clientFname character varying(45), clientLname character varying(45),
			  reservationdate date, bookedBy text)
AS
$$
BEGIN
RETURN QUERY

--Return hotel booking ID, person full name
SELECT DISTINCT roombooking."hotelbookingID", person.fname, person.lname, 
hotelbooking.reservationdate,

--Return 'employee' when the person's ID is in the employee table and 'client' when it isn't 
CASE 
	WHEN EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'employee'
	WHEN NOT EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'client'
END bookedBy
FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) AS rooms

--Find the room bookings of this hotel
INNER JOIN roombooking ON roombooking."roomID" = rooms."idRoom"

--Find the hotel bookings of this room booking
INNER JOIN hotelbooking ON roombooking."hotelbookingID" = hotelbooking.idhotelbooking

--Find the person that booked this hotel booking
INNER JOIN person ON hotelbooking."bookedbyclientID" = person."idPerson";
END; 
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM search_bookings_3_4('89')