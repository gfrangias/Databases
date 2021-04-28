CREATE FUNCTION search_discount_30()
RETURNS TABLE(city character varying(45), country character varying(45)) AS
$$
BEGIN
	RETURN QUERY
		SELECT DISTINCT hotel.city, hotel.country 
		FROM hotel, roomrate
		WHERE hotel."idHotel" = roomrate."idHotel" AND discount > 30;
END;
$$ LANGUAGE 'plpgsql' STABLE;

SELECT search_discount_30();
