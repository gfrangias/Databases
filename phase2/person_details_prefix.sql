CREATE FUNCTION person_details_prefix(hotel_id integer, prefix character varying)
RETURNS TABLE (Client_ID integer, First_Name character varying(45), Last_Name character varying(45),
			  Sex character, Date_Of_Birth date, Address character varying(75), City character varying(45),
			  Country character varying(45))
AS
$$
BEGIN

RETURN QUERY
SELECT DISTINCT person.* FROM (SELECT room.* FROM room 
							   WHERE room."idHotel" = hotel_id) AS r
INNER JOIN roombooking ON roombooking."roomID" = r."idRoom" 
INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID" 
INNER JOIN client ON client."idClient" = hotelbooking."bookedbyclientID" 
INNER JOIN person ON person."idPerson" = client."idClient" 
WHERE left(person.lname, LENGTH(prefix)) = prefix
ORDER BY person.lname ASC;
END;
$$
LANGUAGE 'plpgsql' STABLE;


--SELECT * FROM person_details_prefix('11', 'C');
