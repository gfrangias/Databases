CREATE FUNCTION edit_client_2_1( action action_type, documentclient character varying(45), fname character varying(45), lname character varying(45),
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
		
		--If action insert is performed
		IF action = 'insert' THEN
			--Create new person
			INSERT INTO person(fname, lname, sex, dateofbirth, address, city, country) 
			VALUES (fname, lname, sex, dateofbirth, address, city, country);
			
			--Extract new person ID
			newid = (SELECT max(person."idPerson") FROM person);
			
			--Create new client
			INSERT INTO client(documentclient, "idClient") VALUES (documentclient, newid);
			
			--Create new credit card
			INSERT INTO creditcard(cardtype, number, holder, expiration, "clientID") VALUES (cardtype, number, holder, expiration, newid);
		
		--If action update is performed	
		ELSIF action = 'update' THEN
			--Extract client's ID using documentclient
			updated_id = (SELECT "idClient" FROM client WHERE client.documentclient = edit_client.documentclient);
			
			--Update person
			UPDATE person
			SET fname = edit_client.fname, lname = edit_client.lname, sex = edit_client.sex,
			dateofbirth = edit_client.dateofbirth, address = edit_client.address, city = edit_client.city,
			country = edit_client.country
			WHERE "idPerson" = updated_id;
			
			--Update credit card
			UPDATE creditcard
			SET cardtype = edit_client.cardtype, number = edit_client.number, holder = edit_client.holder, 
			expiration = edit_client.expiration
			WHERE "clientID" = updated_id;
		
		--If action update is performed	
		ELSEIF action = 'delete' THEN
			--Extract client's ID using documentclient
			deleted_id = (SELECT "idClient" FROM client WHERE client.documentclient = edit_client.documentclient);
			
			DELETE FROM person WHERE "idPerson" = deleted_id; 		--delete person
			DELETE FROM client WHERE "idClient" = deleted_id;		--delete client
			DELETE FROM creditcard WHERE "clientID" = deleted_id;	--delete credit card
			
		END IF;
END;
$$
LANGUAGE 'plpgsql'; 
		
--SELECT edit_client_2_1('insert', 'doc6','Chatzis','Thomas', 'M', '1999-06-02','a','a','a','a','13','THOMAS CHATZIS','2021-04-26');
--SELECT edit_client_2_1('update', 'doc6','Frangias','Georgios', 'N', '2000-01-16','b','b','b','b','53','GEORGIOS FRANGIAS','2021-05-30');
--SELECT edit_client_2_1('delete', 'doc6','Frangias','Georgios', 'N', '2000-01-16','b','b','b','b','53','GEORGIOS FRANGIAS','2021-05-30');

				


							 