CREATE FUNCTION search_hotels_with_all_roomtypes_3_8()
RETURNS TABLE(ID integer, Name character varying(45), 
			  City character varying(45), Country character varying(45))
AS
$$
BEGIN

--Update the vacancy of rooms today
PERFORM update_vacancy_of_rooms();

RETURN QUERY
SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel", hotel."name", hotel.city, hotel.country FROM hotel
INNER JOIN room ON hotel."idHotel" = room."idHotel"
-- All distinct room types are equal
WHERE (SELECT count(*) FROM (SELECT DISTINCT room.roomtype FROM room
		WHERE room."idHotel" = hotel."idHotel") as roomtypes) =
-- to all available room types today
	(SELECT count(*) FROM (SELECT DISTINCT room.roomtype FROM room
WHERE room."idHotel" = hotel."idHotel" AND room.vacant = '1') as roomtypes)
GROUP BY hotel."idHotel";

END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM search_hotels_with_all_roomtypes_3_8()