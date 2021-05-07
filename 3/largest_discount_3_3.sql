CREATE FUNCTION largest_discount_3_3()
RETURNS TABLE(idHotel integer, name character varying(45), roomtype character varying(45)) AS
$$
BEGIN
RETURN QUERY

--Return hotel ID, name and room type
SELECT hotel."idHotel", hotel."name", roomrate.roomtype
FROM hotel

--Find the room rates of this hotel
INNER JOIN roomrate ON hotel."idHotel" = roomrate."idHotel" 

--Select the max discount
WHERE roomrate.discount = (SELECT MAX(roomrate.discount) FROM roomrate WHERE roomrate."idHotel" = hotel."idHotel")
ORDER BY roomrate.roomtype ASC;
END;
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM largest_discount_3_3();

