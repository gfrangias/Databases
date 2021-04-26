CREATE FUNCTION insert_person( fname character varying(45), lname character varying(45),
							  sex character(1), dateofbirth date, address character varying(75), city character varying(45),
							 country character varying(45) ) 
		RETURNS VOID AS
		$$
		BEGIN
		
			INSERT INTO person (fname, lname, sex, dateofbirth, address, city, country) VALUES (fname, lname, sex, dateofbirth, address, city, country);
			
		END;
		$$
		LANGUAGE 'plpgsql'; 