CREATE FUNCTION average_age_4_2(room_type character varying(45))
RETURNS SETOF numeric AS 
$$
BEGIN
RETURN QUERY
SELECT TRUNC(AVG(date_part('year', age(person.dateofbirth))::int),2)
FROM (SELECT * FROM roomtype WHERE roomtype.typename = 'Quad') AS rt
INNER JOIN room ON rt.typename = room.roomtype
INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
INNER JOIN person ON person."idPerson" = roombooking."bookedforpersonID";
END;
$$
LANGUAGE 'plpgsql' STABLE;

--SELECT average_age_4_2('Suite')