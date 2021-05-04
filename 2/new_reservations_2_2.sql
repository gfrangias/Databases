 CREATE OR REPLACE FUNCTION public.new_reservations_2_2(
	start_date date,
	end_date date,
	hotel_id integer,
	reservations_num integer)
    RETURNS void AS
$$
DECLARE 
	client_id integer;
	responsible_id integer;
	room_id integer;
	rand_checkin date;
	rand_checkout date;
	reservation_date date;
	cancellation_date date;
	rand_payed boolean;
	num_of_overlapses integer;
	is_employee boolean;
	client_country character varying(45);
	booking_id integer;
	num_rooms integer;
	check_distinct_room boolean;
	
BEGIN
	
	reservation_date = start_date - integer '20';
	cancellation_date = start_date - integer '10';
	-- Check if the tables exist. If so drop them.
	IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'tabletemp') THEN
		DROP TABLE tabletemp;
	END IF;
	IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'overlaps_table') THEN
		DROP TABLE overlaps_table;
	END IF;
	CREATE TEMP TABLE tabletemp(checkin date, checkout date);
	CREATE TEMP TABLE overlaps_table(checkin date, checkout date);
	
	-- Do reservations_num reservations
	FOR i IN 1..reservations_num LOOP
		-- Take a random client ID
		client_id = "idClient" FROM client ORDER BY RANDOM() LIMIT 1;
		client_country = country FROM person WHERE "idPerson" = client_id;
		-- Choose randomly variable payed
		rand_payed = random() > 0.5;
		-- Create a new hotelbooking
		INSERT INTO hotelbooking(reservationdate, cancellationdate, "bookedbyclientID", payed) 
		VALUES (reservation_date, cancellation_date, client_id, rand_payed);
		booking_id = (SELECT max(hotelbooking.idhotelbooking) FROM hotelbooking);
		-- Reserve 1 to 5 rooms
		num_rooms = floor(random() * 5 + 1)::int;
		
		FOR i IN 1..num_rooms LOOP
			-- Check if this room was booked for the same hotelbooking
			LOOP
			-- Choose a random room from the given hotel
			room_id = "idRoom" FROM room WHERE "idHotel" = hotel_id ORDER BY RANDOM() LIMIT 1;
			check_distinct_room = count(1) > 0 FROM roombooking WHERE "hotelbookingID" = booking_id AND "roomID" = room_id;
			EXIT WHEN check_distinct_room = false;
			END LOOP;
			
			LOOP
				-- Choose random checkin/checkout dates from the given dates
				rand_checkin = date(start_date::date + trunc(random() * (end_date - start_date)) * '1 day'::interval);
				rand_checkout = date(rand_checkin::date + trunc(random() * (end_date - rand_checkin)) * '1 day'::interval);
				-- Delete the temporary tables 
				DELETE FROM tabletemp;
				DELETE FROM overlaps_table;
				-- Find the previous reservations of this room
				INSERT INTO tabletemp(checkin, checkout) SELECT checkin, checkout FROM roombooking WHERE "roomID" = room_id;
				-- Check for overlaps
				INSERT INTO overlaps_table SELECT * FROM tabletemp WHERE (tabletemp.checkin, tabletemp.checkout) OVERLAPS (rand_checkin, rand_checkout);
				num_of_overlapses = COUNT(*) FROM overlaps_table;
				EXIT WHEN num_of_overlapses = 0;
			END LOOP;

			-- Choose responsible person if the person isn't employee
			LOOP
				-- Take a random person ID that comes from the same country
				responsible_id = "idPerson" FROM person WHERE person.country = client_country ORDER BY RANDOM() LIMIT 1;
				-- Check if they are employee
				is_employee = count(1) > 0 FROM employee WHERE "idEmployee" = responsible_id;
				EXIT WHEN is_employee = false;
			END LOOP;
			-- Create the new room booking
			INSERT INTO roombooking("hotelbookingID", "roomID", "bookedforpersonID", checkin, checkout)
					VALUES (booking_id, room_id, responsible_id, rand_checkin, rand_checkout);
		END LOOP;
	END LOOP;
END;
$$
LANGUAGE 'plpgsql';

--SELECT new_reservations_2_2('2021-06-01', '2021-10-01', '65', '10');
