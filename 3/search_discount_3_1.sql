CREATE FUNCTION search_discount_3_1()
RETURNS TABLE(city character varying(45), country character varying(45)) AS
$$
BEGIN
	RETURN QUERY
		-- Return the cities and countries 
		SELECT DISTINCT hotel.city, hotel.country 
		FROM hotel, roomrate
		WHERE hotel."idHotel" = roomrate."idHotel" AND discount > 30;	--where discount > 30%
END;
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM search_discount_3_1();
