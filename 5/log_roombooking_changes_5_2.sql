CREATE OR REPLACE FUNCTION log_roombooking_changes_5_2()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	
	-- If delete is performed
	IF (TG_OP = 'DELETE') THEN
	
		-- If cancellation date has passed
		-- Raise exception and stop action
		IF (SELECT (SELECT hotelbooking.cancellationdate 
		  						FROM hotelbooking 
		 						 WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID") < NOW()) THEN
			RAISE EXCEPTION 'You cannot delete a room booking past cancellation date: %
			Only the hotel manager can alter the cancellation date in order to delete booking.
			Please ask them to alter the cancelation date of the hotel booking with ID: %', 
			(SELECT hotelbooking.cancellationdate 
			FROM hotelbooking 
			WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID"), OLD."hotelbookingID";
		END IF;
		
		-- Update hotelbooking by subtracting value from totalamount
		UPDATE hotelbooking 
		SET totalamount = totalamount - (OLD.checkout - OLD.checkin) * OLD.rate
		WHERE idhotelbooking = OLD."hotelbookingID";
		
		-- If hotelbooking is already payed update transaction
		IF(SELECT hotelbooking.payed FROM hotelbooking 
		   WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID") THEN
		
			-- Update the payment transaction
			UPDATE "transaction"
			SET amount = (SELECT hotelbooking.totalamount 
					  FROM hotelbooking 
					  WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID")
			WHERE "action" = 'payment' AND idhotelbooking = OLD."hotelbookingID";
		
			-- Create a refund transaction
			INSERT INTO "transaction"("action", amount, idhotelbooking, date)
			VALUES('refund', (OLD.checkout - OLD.checkin) * OLD.rate, OLD."hotelbookingID", NOW()::date);
		END IF;
	END IF;
	
	IF (TG_OP = 'UPDATE') THEN
	
	
		IF (SELECT (SELECT hotelbooking.cancellationdate 
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
		
		IF(NEW.checkout <> OLD.checkout) THEN
			IF (SELECT count(*) FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = OLD."roomID" 
				    AND roombooking."hotelbookingID" <> OLD."hotelbookingID") AS roombookings
					WHERE (roombookings.checkin, roombookings.checkout) 
					OVERLAPS (NEW.checkin, NEW.checkout)) > '0' THEN		
				
				RAISE NOTICE 'You have attempted to alter the checkin/checkout dates of room -> %
				in hotel booking -> %
				But this overlapses with another booking for this room.
				Room % is available for booking until: %',
				OLD."roomID", OLD."hotelbookingID", OLD."roomID",
				checkin FROM roombooking WHERE roombooking."roomID" = OLD."roomID"
				ORDER BY checkout ASC
				OFFSET (SELECT s.position
  						FROM (SELECT roombookings.*,
               			ROW_NUMBER() OVER(ORDER BY roombookings.checkout ASC) AS position
          				FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = OLD."roomID") AS roombookings) s
 				WHERE s."hotelbookingID" = OLD."hotelbookingID") 
				LIMIT 1;
				NEW.checkout = OLD.checkout;
			ELSE 
				RAISE NOTICE 'You have successfully altered the checkout date for room -> %
				in hotel booking -> %
				to date -> %
				FYI rooom % is available for booking until: %',	
				OLD."roomID", OLD."hotelbookingID", NEW.checkout, OLD."roomID",
				checkin FROM roombooking WHERE roombooking."roomID" = OLD."roomID"
				ORDER BY checkout ASC
				OFFSET (SELECT s.position
  						FROM (SELECT roombookings.*,
               			ROW_NUMBER() OVER(ORDER BY roombookings.checkout ASC) AS position
          				FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = OLD."roomID") AS roombookings) s
 				WHERE s."hotelbookingID" = OLD."hotelbookingID") 
				LIMIT 1;			
			END IF;
		END IF;
		
		UPDATE hotelbooking
		SET totalamount = totalamount + (NEW.checkout - NEW.checkin - (OLD.checkout - OLD.checkin)) * OLD.rate
		WHERE idhotelbooking = OLD."hotelbookingID";
		
		-- If hotelbooking is already payed update transaction
		IF(SELECT hotelbooking.payed FROM hotelbooking 
		   WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID") THEN
		
			-- Update the payment transaction
			UPDATE "transaction"
			SET amount = (SELECT hotelbooking.totalamount 
					  FROM hotelbooking 
					  WHERE hotelbooking.idhotelbooking = OLD."hotelbookingID")
			WHERE "action" = 'payment' AND idhotelbooking = OLD."hotelbookingID";
			
			IF ((NEW.checkout - NEW.checkin - (OLD.checkout - OLD.checkin)) * OLD.rate > 0) THEN
				-- Create a re-payment transaction
				INSERT INTO "transaction"("action", amount, idhotelbooking, date)
				VALUES('re-payment', (NEW.checkout - NEW.checkin - (OLD.checkout - OLD.checkin)) * OLD.rate
					   , OLD."hotelbookingID", NOW()::date);
			ELSE
				-- Create a refund transaction
				INSERT INTO "transaction"("action", amount, idhotelbooking, date)
				VALUES('refund', (NEW.checkout - NEW.checkin - (OLD.checkout - OLD.checkin)) * OLD.rate
					   , OLD."hotelbookingID", NOW()::date);				
			END IF;
		END IF;
	END IF;

	IF(TG_OP = 'INSERT') THEN 
	
		IF (SELECT count(*) FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = NEW."roomID" 
				    AND roombooking."hotelbookingID" <> NEW."hotelbookingID") AS roombookings
					WHERE (roombookings.checkin, roombookings.checkout) 
					OVERLAPS (NEW.checkin, NEW.checkout)) > '0' THEN		
			RAISE EXCEPTION 'You have attempted to insert a new booking of room -> %
			in hotel booking -> %
			But this overlapses with another booking for this room.
			Please try other checkin/checkout dates.',
			NEW."roomID", NEW."hotelbookingID";
		END IF;
					
		UPDATE hotelbooking
		SET totalamount = totalamount + (NEW.checkout - NEW.checkin) * NEW.rate
		WHERE idhotelbooking = NEW."hotelbookingID";
		
		-- If hotelbooking is already payed update transaction
		IF(SELECT hotelbooking.payed FROM hotelbooking 
		   WHERE hotelbooking.idhotelbooking = NEW."hotelbookingID") THEN
		
			-- Update the payment transaction
			UPDATE "transaction"
			SET amount = (SELECT hotelbooking.totalamount 
					  FROM hotelbooking 
					  WHERE hotelbooking.idhotelbooking = NEW."hotelbookingID")
			WHERE "action" = 'payment' AND idhotelbooking = NEW."hotelbookingID";
			
			-- Create a refund transaction
			INSERT INTO "transaction"("action", amount, idhotelbooking, date)
			VALUES('re-payment', (NEW.checkout - NEW.checkin) * NEW.rate, NEW."hotelbookingID", NOW()::date);
			
		END IF;
	END IF;
	
	IF(TG_OP = 'DELETE') THEN 
		RETURN OLD;
	END IF;
	
	IF(TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
		RETURN NEW;
	END IF;
END;
$$
LANGUAGE 'plpgsql';

/*

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

-- Delete and update amount and transaction
INSERT INTO roombooking("hotelbookingID", "roomID", checkin, checkout, rate)
VALUES('4898','292',date '2021-05-06', date '2021-05-08', '10')

DELETE FROM roombooking
WHERE roombooking."hotelbookingID" = '4898' AND roombooking."roomID" = '292'

SELECT * FROM roombooking 
WHERE roombooking."hotelbookingID" = '4898' AND roombooking."roomID" = '292'

SELECT * FROM hotelbooking
WHERE hotelbooking.idhotelbooking = '4898'

SELECT * FROM "transaction" WHERE "transaction".idhotelbooking = '4898'

SELECT (SELECT * FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = '293') AS roombookings
WHERE (roombookings.checkin, roombookings.checkout) 
OVERLAPS (date '2021-05-05',date '2021-05-10' )) > '0'

SELECT * FROM roombooking WHERE roombooking."roomID" = '293'

SELECT * FROM roombooking WHERE roombooking."roomID" = '293'
ORDER BY checkout ASC
OFFSET (SELECT s.position
  		FROM (SELECT roombookings.*,
               	ROW_NUMBER() OVER(ORDER BY roombookings.checkout ASC) AS position
          		FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = '293') AS roombookings) s
 		WHERE s."hotelbookingID" = '2911') 
LIMIT 1 


SELECT s.position
  FROM (SELECT roombookings.*,
               ROW_NUMBER() OVER(ORDER BY roombookings.checkout ASC) AS position
          FROM (SELECT * FROM roombooking WHERE roombooking."roomID" = '293') AS roombookings) s
 WHERE s."hotelbookingID" = '2911'
 
 UPDATE roombooking
 SET checkout = '2021-08-16'
 WHERE roombooking."hotelbookingID" = '2911' AND roombooking."roomID" = '293';
 
 SELECT * FROM hotelbooking WHERE hotelbooking.idhotelbooking = '2911';
 
 SELECT update_total_amount()
 
 SELECT * FROM hotelbooking WHERE hotelbooking.idhotelbooking = '17'
 
 SELECT * FROM "transaction" WHERE "transaction".idhotelbooking = '17'
 
 SELECT * FROM roombooking WHERE roombooking."hotelbookingID" = '17'
 
 INSERT INTO roombooking("hotelbookingID", "roomID", "bookedforpersonID", checkin, checkout, rate)
 VALUES('17','293','4554',date '2021-05-28',date '2021-06-01', '71.5')
 */