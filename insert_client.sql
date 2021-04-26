CREATE FUNCTION insert_client( documentclient character varying(45), fname character varying(45), lname character varying(45),
							  sex character(1), dateofbirth date, address character varying(75), city character varying(45),
							 country character varying(45), cardtype character varying(30), number character varying(45),
							 holder character varying(45), expiration date ) 
		RETURNS integer AS
		$$
		DECLARE 
			newid integer;
		BEGIN
			INSERT INTO person(fname, lname, sex, dateofbirth, address, city, country) 
			VALUES (fname, lname, sex, dateofbirth, address, city, country);
			
			INSERT INTO client(documentclient) VALUES (documentclient);
			
			INSERT INTO creditcard(cardtype, number, holder, expiration) VALUES (cardtype, number, holder, expiration);

END;
$$
LANGUAGE 'plpgsql'; 
		
SELECT insert_client('doc','Chatzis','Thomas', 'M', '1999-06-02','a','a','a','a','12','THOMAS CHATZIS','2021-04-26');

				


							 