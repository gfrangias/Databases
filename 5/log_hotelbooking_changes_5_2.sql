CREATE OR REPLACE FUNCTION log_hotelbooking_changes_5_2()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	--If 
	IF  (TG_OP = 'UPDATE') AND (NEW.cancellationdate <> OLD.cancellationdate) THEN
		 --
		 IF ((SELECT employee.idmanager FROM employee 
			 						WHERE employee."idEmployee" = OLD."bookedbyclientID") 
									IS NOT NULL)  OR 
									((SELECT client."idClient" FROM client 
			 						WHERE client."idClient" = OLD."bookedbyclientID") 
									IS NOT NULL AND (SELECT employee."idEmployee" FROM employee 
			 						WHERE employee."idEmployee" = OLD."bookedbyclientID") 
									IS NULL)
									THEN 
			NEW.cancellationdate = OLD.cancellationdate;
			RAISE NOTICE 'You have attempted to alter the cancellation date of hotel booking: %
			Only a manager has permission to perform this action.
			All other changes saved except for cancellation date.', OLD.idhotelbooking;
		 END IF;
	END IF;
	
	IF (TG_OP = 'DELETE') AND (OLD.cancellationdate < NOW()) THEN
		RAISE EXCEPTION 'You cannot delete a hotel booking past cancellation date: %
		Only the hotel manager can alter the cancellation date in order to delete booking.
		Please ask them to alter the cancelation date of the hotel booking with ID: %', 
		OLD.cancellationdate, OLD.idhotelbooking;
	END IF;
	
	--Return trigger	
	IF(TG_OP = 'DELETE') THEN 
		RETURN OLD;
	END IF;
	
	IF(TG_OP = 'UPDATE') THEN
		RETURN NEW;
	END IF;
END;
$$
LANGUAGE 'plpgsql';

-- Employee non-manager
UPDATE hotelbooking
SET cancellationdate = '2021-08-15', totalamount = '100'
WHERE hotelbooking.idhotelbooking = '3170';

SELECT * FROM hotelbooking WHERE hotelbooking.idhotelbooking = '3170';

-- Employee manager
UPDATE hotelbooking
SET cancellationdate = '2022-03-10' 
WHERE hotelbooking.idhotelbooking = '5906';

SELECT * FROM hotelbooking WHERE hotelbooking.idhotelbooking = '5906';

-- Client non-employee
UPDATE hotelbooking
SET cancellationdate = '2021-12-12' 
WHERE hotelbooking.idhotelbooking = '4561';

SELECT * FROM hotelbooking WHERE hotelbooking.idhotelbooking = '4561';

-- Delete past the cancellation date
DELETE FROM hotelbooking
WHERE hotelbooking.idhotelbooking = '17'
