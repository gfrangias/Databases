CREATE TRIGGER hotelbooking_changes_5_2
 	BEFORE UPDATE OR DELETE
  	ON hotelbooking
  	FOR EACH ROW
  	EXECUTE PROCEDURE log_hotelbooking_changes_5_2();