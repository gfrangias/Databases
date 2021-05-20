CREATE VIEW available_hotel_rooms_6_1 AS

	SELECT DISTINCT ON (roombooking."roomID") roombooking."roomID",
	rooms.roomtype, roombooking.checkin, sel_hotel."idHotel"
	FROM (SELECT * FROM hotel WHERE hotel."idHotel" = '11') AS sel_hotel
	INNER JOIN room AS rooms ON rooms."idHotel" = sel_hotel."idHotel"
	INNER JOIN roombooking ON roombooking."roomID" = rooms."idRoom"
	WHERE rooms.vacant = '1' AND roombooking.checkin > NOW()::date
	ORDER BY roombooking."roomID", roombooking.checkin;

--SELECT * FROM available_hotel_rooms_6_1;
