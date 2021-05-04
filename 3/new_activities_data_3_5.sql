---------------------------------------------------------------------------------
-- DESCRIPTION
-- Function created to initialize a number of activities so that 3.5 function can 
-- be performed
--
-- PARAMETERS
-- activities_num: number of activities to initialize
-- start_time, end_time: all activities will be placed in between those two dates
--
-- COMMENTS
-- Every variable of the activity is randomly chosen except for the participants.
-- Participants are required to have, at least once, booked in the same hotel as 
-- the one the activity takes place in.
--
-- Every activity has a duration of 3 hours.
---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION new_activities_data_3_5(start_time timestamp, end_time timestamp, activities_num integer)
RETURNS VOID  AS
$$
DECLARE
	hotel_id integer;
	employee_id integer;
	starting_time timestamp;
	ending_time timestamp;
	week_day text;
	activ_type activity_type;
	participants_num integer;
	participant_id integer;
	rol_type role_type;
BEGIN 

	FOR i IN 1..activities_num LOOP

		--Check if the temporary table exists and delete if so
		IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'participants') THEN
			DROP TABLE participants;
		END IF;

		--Create the temporary table for the participants 
		CREATE TEMP TABLE participants(participant_id integer);
		
		--Randomly choose a hotel, a starting time and set ending time 3 hours later
		hotel_id = "idHotel" FROM hotel ORDER BY RANDOM() LIMIT 1;
		starting_time = start_time + date_trunc('second', random() * (end_time - start_time));
		ending_time = starting_time + interval '3 hours';
		
		--Use custom function 'timestamp_to_weekday' to set week_day variable
		week_day = * FROM timestamp_to_weekday(starting_time);

		--Choose a random activity type
		activ_type = rand_activity_type 
						FROM ( SELECT unnest(enum_range(NULL::activity_type)) 
			 			as rand_activity_type ) sub ORDER BY random() LIMIT 1;
		
		--Choose a random employee
		employee_id = "idEmployee" FROM employee ORDER BY RANDOM() LIMIT 1;

		--Create a new activity
		INSERT INTO activity(idhotel, starttime, endtime, weekday, activitytype, reservedbyemployee)
		VALUES (hotel_id, starting_time, ending_time, week_day::weekday, activ_type, employee_id);
		
		--Randomly choose a number of participants between 0-10
		participants_num = FLOOR(random() * 10);
		
		--Select the first 0-10 clients that booked in this hotel and save their IDs in 
		--the temporary table 'participants'
		INSERT INTO participants(participant_id)  SELECT DISTINCT hotelbooking."bookedbyclientID"
							FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) AS r
							INNER JOIN roombooking ON roombooking."roomID" = r."idRoom"
							INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID"
							LIMIT participants_num;
		
		FOR i IN 1..participants_num LOOP
			--If there are no participants exit loop
			EXIT WHEN participants_num = 0;

			--Choose a random role type
			rol_type = rand_role_type 
						FROM ( SELECT unnest(enum_range(NULL::role_type)) 
			 			as rand_role_type ) sub ORDER BY random() LIMIT 1;
			
			--Create a new participant from the temporary table 'participants'
			INSERT INTO participates("idPerson", starttime, endtime, weekday, idhotel, role)
			VALUES ((SELECT * FROM participants AS id_part OFFSET i-1 LIMIT 1),
					starting_time, ending_time, week_day::weekday, hotel_id, rol_type);
		END LOOP;
		
	END LOOP;
END;
$$
LANGUAGE 'plpgsql';

--SELECT new_activities_data_3_5('2021-05-28 14:56:52', '2021-08-02 14:58:52', '200');
							
							
							
