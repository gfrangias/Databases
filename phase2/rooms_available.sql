CREATE FUNCTION rooms_available(start_date date, end_date date, hotel_id integer)
RETURNS TABLE (Room_ID integer, Number integer, Room_Type character varying)
AS
$$
BEGIN

RETURN QUERY
WITH rooms_not_available AS(
SELECT DISTINCT room."idRoom"
FROM (SELECT * FROM hotel WHERE hotel."idHotel" = hotel_id) AS h
INNER JOIN room ON room."idHotel" = h."idHotel"
INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
WHERE (roombooking.checkin, roombooking.checkout) OVERLAPS (start_date, end_date)
)
SELECT DISTINCT room."idRoom", room.number, room.roomtype
FROM (SELECT * FROM hotel WHERE hotel."idHotel" = hotel_id) AS h
INNER JOIN room ON room."idHotel" = h."idHotel"
INNER JOIN roombooking ON roombooking."roomID" = room."idRoom"
WHERE NOT EXISTS (SELECT 1 FROM rooms_not_available WHERE room."idRoom" = rooms_not_available."idRoom");

END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM rooms_available('2021-05-19','2021-05-28', '11');
