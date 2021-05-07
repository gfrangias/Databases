CREATE TRIGGER roombooking_changes_5_2
 	BEFORE INSERT OR UPDATE OR DELETE
  	ON roombooking
  	FOR EACH ROW
  	EXECUTE PROCEDURE log_roombooking_changes_5_2();