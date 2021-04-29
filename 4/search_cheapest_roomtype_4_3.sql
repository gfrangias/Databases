CREATE FUNCTION search_cheapest_roomtype_4_3(sel_country character varying(45))
RETURNS TABLE(roomtype character varying(45), min_price real, idHotel integer, 
			  name character varying(45), city character varying(45))
AS
$$
BEGIN
RETURN QUERY
SELECT DISTINCT ON (roomrate.roomtype) roomrate.roomtype, MIN(roomrate.rate),
					hotels."idHotel", hotels.name, hotels.city
FROM (SELECT * FROM hotel WHERE hotel.country = sel_country) AS hotels
INNER JOIN roomrate ON hotels."idHotel" = roomrate."idHotel"
GROUP BY roomrate.roomtype, roomrate.rate, hotels."idHotel", hotels.name, hotels.city
ORDER BY roomrate.roomtype, roomrate.rate ASC;
END;
$$
LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM search_cheapest_roomtype_4_3('United States')

