CREATE FUNCTION largest_discount_3_3()
RETURNS TABLE(idHotel integer, name character varying(45), roomtype character varying(45)) AS
$$
BEGIN
RETURN QUERY
SELECT hotel."idHotel", hotel."name", roomrate.roomtype
FROM hotel
INNER JOIN roomrate ON hotel."idHotel" = roomrate."idHotel" 
WHERE roomrate.discount = (SELECT MAX(roomrate.discount) FROM roomrate)
ORDER BY roomrate.roomtype ASC;
END;
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT largest_discount_3_3();

