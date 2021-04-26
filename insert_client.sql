CREATE FUNCTION insert_client( documenclient character varying(45), fname character varying(45), lname character varying(45),
							  sex character(1), dateofbirth date, address character varying(75), city character varying(45),
							 country character varying(45), cardtype character varying(30), number character varying(45),
							 holder character varying(45), expiration date ) 
		RETURNS VOID AS
		$$
		BEGIN
		
			INSERT INTO person(fname, lname, sex, dateofbirth, address, city, country) VALUES (fname, lname, sex, dateofbirth, address, city, country);
			INSERT INTO client(documenclient, ) VALUES (documenclient)
			
			INSERT INTO creditcard(cardtype, number, holder, expiration, holder) VALUES (cardtype, number, holder, expiration)

		END;
		$$
		LANGUAGE 'plpgsql'; 
				
							 