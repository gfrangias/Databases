CREATE FUNCTION new_reservations(start_date date, end_date date, hotel_id integer, reservations_num integer)
RETURNS VOID AS
$$
DECLARE 
	client_id integer := '0';
	responsible_id integer;
	rand_checkin date;
	rand_checkout date;
	reservation_date date;
	cancellation_date date;
	rand_payed BOOLEAN;
BEGIN
	
	reservation_date = start_date - integer '20';
	cancellation_date = start_date - integer '10'; 

	FOR i IN 1..reservations_num LOOP
		client_id = "idClient" FROM client ORDER BY RANDOM() LIMIT 1;
		rand_payed = random() > 0.5;
		INSERT INTO hotelbooking(reservationdate, cancellationdate, "bookedbyclientID", payed) 
		VALUES (reservation_date, cancellation_date, client_id, rand_payed);
	END LOOP;
	
	
END;
$$
LANGUAGE 'plpgsql';

 SELECT new_reservations('2021-06-01', '2021-10-01', '65', '10');