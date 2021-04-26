CREATE FUNCTION edit_client( action action_type, documentclient character varying(45), fname character varying(45), lname character varying(45),
							  sex character(1), dateofbirth date, address character varying(75), city character varying(45),
							 country character varying(45), cardtype character varying(30), number character varying(45),
							 holder character varying(45), expiration date ) 
		RETURNS VOID AS
		$$
		DECLARE 
			newid integer;
			updated_id integer;
			deleted_id integer;
		BEGIN
		
		IF action = 'insert' THEN
			INSERT INTO person(fname, lname, sex, dateofbirth, address, city, country) 
			VALUES (fname, lname, sex, dateofbirth, address, city, country);
			
			newid = (SELECT max(person."idPerson") FROM person);
			
			INSERT INTO client(documentclient, "idClient") VALUES (documentclient, newid);
			
			INSERT INTO creditcard(cardtype, number, holder, expiration, "clientID") VALUES (cardtype, number, holder, expiration, newid);
			
		ELSIF action = 'update' THEN
			updated_id = (SELECT "idClient" FROM client WHERE client.documentclient = edit_client.documentclient);
			
			UPDATE person
			SET fname = edit_client.fname, lname = edit_client.lname, sex = edit_client.sex,
			dateofbirth = edit_client.dateofbirth, address = edit_client.address, city = edit_client.city,
			country = edit_client.country
			WHERE "idPerson" = updated_id;
			
			UPDATE creditcard
			SET cardtype = edit_client.cardtype, number = edit_client.number, holder = edit_client.holder, 
			expiration = edit_client.expiration
			WHERE "clientID" = updated_id;
			
		ELSE
			deleted_id = (SELECT "idClient" FROM client WHERE client.documentclient = edit_client.documentclient);
			
			DELETE FROM person WHERE "idPerson" = deleted_id;
			DELETE FROM client WHERE "idClient" = deleted_id;
			DELETE FROM creditcard WHERE "clientID" = deleted_id;
			
		END IF;
END;
$$
LANGUAGE 'plpgsql'; 
		
--SELECT edit_client('insert', 'doc6','Chatzis','Thomas', 'M', '1999-06-02','a','a','a','a','13','THOMAS CHATZIS','2021-04-26');
--SELECT edit_client('update', 'doc6','Frangias','Georgios', 'N', '2000-01-16','b','b','b','b','53','GEORGIOS FRANGIAS','2021-05-30');
SELECT edit_client('delete', 'doc6','Frangias','Georgios', 'N', '2000-01-16','b','b','b','b','53','GEORGIOS FRANGIAS','2021-05-30');

				


							 