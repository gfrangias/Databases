CREATE FUNCTION update_vacancy_of_rooms()
RETURNS VOID
AS
$$
DECLARE 
	overlaps_count integer;
	i record;
BEGIN

FOR i IN (SELECT * FROM room) LOOP
	-- Check for roombookings that are ongoing now
	overlaps_count = (
		SELECT count(*) FROM roombooking 
		WHERE (roombooking.checkin, roombooking.checkout) 
		OVERLAPS (NOW()::date, NOW()::date) AND
		roombooking."roomID" = i."idRoom"
	);
	
	-- If there aren't ongoing bookings  
	IF overlaps_count = 0 THEN
		UPDATE room
		SET vacant = '1'
		WHERE room."idRoom" = i."idRoom";
	ELSE
		UPDATE room
		SET vacant = '0'
		WHERE room."idRoom" = i."idRoom";	
	END IF;
	
END LOOP;

END;
$$
LANGUAGE 'plpgsql';


--SELECT update_vacancy_of_rooms()