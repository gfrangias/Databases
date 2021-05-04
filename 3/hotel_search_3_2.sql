CREATE FUNCTION hotel_search_3_2(prefix character varying(45), num_stars character varying(10))
RETURNS TABLE( idHotel integer,
    name character varying(45),
    stars character varying(10),
    address character varying(75),
    city character varying(45),
    country character varying(45),
    phone character varying(25),
    fax character varying(25) ) AS
$$
BEGIN
RETURN QUERY
SELECT DISTINCT hotel.*
FROM hotel
--Find the rooms of this hotel
INNER JOIN room ON hotel."idHotel" = room."idHotel"

--Find the 'Studios' where the rate with discount is < 80$
INNER JOIN roomrate ON hotel."idHotel" = roomrate."idHotel" AND roomrate.roomtype = 'Studio' 
					AND roomrate.rate - ( (roomrate.discount * roomrate.rate) /100) < 80

--The hotel should have 'Breakfast' and 'Restaurant' facilities
INNER JOIN hotelfacilities ON hotel."idHotel" = hotelfacilities."idHotel" AND 
(SELECT count(1) = 2 FROM hotelfacilities WHERE ( hotelfacilities."idHotel" = hotel."idHotel" AND 
												 (hotelfacilities."nameFacility" = 'Breakfast' 
												 OR hotelfacilities."nameFacility" = 'Restaurant')))		
WHERE hotel.stars = num_stars AND  left(hotel."name", LENGTH(prefix))= prefix;
END;
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM hotel_search_3_2('B', '4');