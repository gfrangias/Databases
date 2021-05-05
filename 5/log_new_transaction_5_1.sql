CREATE OR REPLACE FUNCTION log_new_transaction_5_1()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	--If hotel booking changes from not payed to payed
	IF NEW.payed AND NOT OLD.payed THEN
		 --Create new transaction with action name 'payment'
		 INSERT INTO transaction(action, amount, idhotelbooking, date)
		 VALUES('payment', NEW.totalamount, NEW.idhotelbooking, NOW()::date);
	END IF;
	--Return trigger
	RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
