CREATE TRIGGER new_transaction_5_1
  	--Check for updates on hotelbooking
 	BEFORE UPDATE
  	ON hotelbooking
  	FOR EACH ROW
  	EXECUTE PROCEDURE log_new_transaction_5_1();