CREATE FUNCTION update_total_amount()
RETURNS VOID AS
$$
BEGIN
FOR i IN 1..6514 LOOP
UPDATE hotelbooking 
SET totalamount = earnings.sum FROM (SELECT SUM(roombooking.rate * (roombooking.checkout - roombooking.checkin))
					FROM roombooking
					WHERE roombooking."hotelbookingID" = i) AS earnings
WHERE hotelbooking.idhotelbooking = i;
END LOOP;
END;
$$
LANGUAGE 'plpgsql';

--SELECT update_total_amount()