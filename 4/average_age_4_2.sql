CREATE FUNCTION average_age_4_2(room_type character varying(45))
RETURNS SETOF numeric AS 
$$
BEGIN
RETURN QUERY

--Return the average age of the clients booking rooms
SELECT TRUNC(AVG(date_part('year', age(person.dateofbirth))::int),2)

-- Get the persons that have booked a room of this room type
FROM (SELECT * FROM roomtype WHERE roomtype.typename = room_type) AS rt
INNER JOIN room ON rt.typename = room.roomtype
INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
INNER JOIN person ON person."idPerson" = roombooking."bookedforpersonID";
END;
$$
LANGUAGE 'plpgsql' STABLE;

--SELECT average_age_4_2('Quad')