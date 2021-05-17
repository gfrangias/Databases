CREATE FUNCTION search_hotel_room_facilities_3_7(hotel_facility character varying(45), room_facility character varying(45))
RETURNS TABLE(Room_ID integer, Hotel_ID integer, Hotel_Name character varying(45))
AS
$$
BEGIN

RETURN QUERY
SELECT DISTINCT ON(room."idRoom") room."idRoom",room."idHotel", 
(SELECT hotel."name" FROM hotel WHERE hotel."idHotel" = room."idHotel")
FROM room
INNER JOIN hotelfacilities ON hotelfacilities."idHotel" = room."idHotel"
INNER JOIN roomfacilities ON roomfacilities."idRoom" = room."idRoom"
INNER JOIN (SELECT * FROM roombooking 
			WHERE NOT (roombooking.checkin, roombooking.checkout) 
			OVERLAPS (NOW()::date, NOW()::date)) as roombookings
ON roombookings."roomID" = room."idRoom" 
INNER JOIN hotel ON hotel."idHotel" = room."idHotel"
WHERE hotelfacilities."nameFacility" = hotel_facility AND
roomfacilities."nameFacility" = room_facility
ORDER BY room."idRoom";

END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM search_hotel_room_facilities_3_7('Bar', 'Vodka')