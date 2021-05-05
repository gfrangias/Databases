CREATE OR REPLACE FUNCTION log_roombooking_changes_5_2()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	
	IF (TG_OP = 'DELETE') AND (SELECT (SELECT hotelbooking.cancellationdate 
		  						FROM hotelbooking 
		 						 WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID") < NOW()) THEN
		RAISE EXCEPTION 'You cannot delete a room booking past cancellation date: %
		Only the hotel manager can alter the cancellation date in order to delete booking.
		Please ask them to alter the cancelation date of the hotel booking with ID: %', 
		(SELECT hotelbooking.cancellationdate 
		 FROM hotelbooking 
		 WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID"), OLD."hotelbookingID";
	END IF;
	
	IF (TG_OP = 'UPDATE') AND (SELECT (SELECT hotelbooking.cancellationdate 
		  						FROM hotelbooking 
		 						 WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID") < NOW()) THEN
		IF (NEW.checkout - NEW.checkin) < (OLD.checkout - NEW.checkin) THEN
			RAISE NOTICE 'You have attempted to alter the checkin/checkout dates of room -> %
			in hotel booking -> %
			past cancellation date: %
			Only the hotel manager can alter the cancellation date in order to change booking dates.
			Please ask them to alter the cancelation date of the hotel booking with ID: %', 
			OLD."roomID", OLD."hotelbookingID", 
			(SELECT hotelbooking.cancellationdate 
		  						FROM hotelbooking 
		 						 WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID"),
			OLD."hotelbookingID";
			NEW.checkout = OLD.checkout;
			NEW.checkin = OLD.checkin;
		END IF;
	END IF;
	
	IF(TG_OP = 'DELETE') THEN 
		RETURN OLD;
	END IF;
	
	IF(TG_OP = 'UPDATE') THEN
		RETURN NEW;
	END IF;
END;
$$
LANGUAGE 'plpgsql';

SELECT hotelbooking.cancellationdate FROM hotelbooking WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID"
SELECT hotelbooking.cancellationdate FROM hotelbooking WHERE hotelbooking.idhotelbooking = '17'

-- Delete past the cancellation date
DELETE FROM roombooking
WHERE roombooking."roomID" = '1821' AND roombooking."hotelbookingID" = '17'

-- Successful delete
DELETE FROM roombooking
WHERE roombooking."roomID" = '261' AND roombooking."hotelbookingID" = '117'

SELECT roombooking.* 
FROM roombooking 
WHERE roombooking."roomID" = '261' AND roombooking."hotelbookingID" = '117'

-- Update past the cancellation date less days
UPDATE roombooking
SET checkout = date '2021-02-13'
WHERE roombooking."roomID" = '1821' AND roombooking."hotelbookingID" = '17'

SELECT roombooking.* 
FROM roombooking 
WHERE roombooking."roomID" = '1821' AND roombooking."hotelbookingID" = '17'

-- Update past the cancellation date more days
UPDATE roombooking
SET checkout = date '2021-02-15'
WHERE roombooking."roomID" = '1821' AND roombooking."hotelbookingID" = '17'

SELECT roombooking.* 
FROM roombooking 
WHERE roombooking."roomID" = '1821' AND roombooking."hotelbookingID" = '17'
