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
		IF EXISTS (SELECT relname FROM pg_class WHERE relname = 'participants') THEN
			DROP TABLE participants;
		END IF;
	
		CREATE TEMP TABLE participants(participant_id integer);
		
		hotel_id = "idHotel" FROM hotel ORDER BY RANDOM() LIMIT 1;
		starting_time = start_time + date_trunc('second', random() * (end_time - start_time));
		ending_time = starting_time + interval '3 hours';
		week_day = * FROM timestamp_to_weekday(starting_time);
		activ_type = rand_activity_type 
						FROM ( SELECT unnest(enum_range(NULL::activity_type)) 
			 			as rand_activity_type ) sub ORDER BY random() LIMIT 1;
		employee_id = "idEmployee" FROM employee ORDER BY RANDOM() LIMIT 1;
		INSERT INTO activity(idhotel, starttime, endtime, weekday, activitytype, reservedbyemployee)
		VALUES (hotel_id, starting_time, ending_time, week_day::weekday, activ_type, employee_id);
		
		participants_num = FLOOR(random() * 10);
		
		INSERT INTO participants(participant_id)  SELECT DISTINCT hotelbooking."bookedbyclientID"
							FROM (SELECT * FROM room WHERE room."idHotel" = hotel_id) AS r
							INNER JOIN roombooking ON roombooking."roomID" = r."idRoom"
							INNER JOIN hotelbooking ON hotelbooking.idhotelbooking = roombooking."hotelbookingID"
							LIMIT participants_num;
		
		FOR i IN 1..participants_num LOOP
			EXIT WHEN participants_num = 0;
			rol_type = rand_role_type 
						FROM ( SELECT unnest(enum_range(NULL::role_type)) 
			 			as rand_role_type ) sub ORDER BY random() LIMIT 1;
			INSERT INTO participates("idPerson", starttime, endtime, weekday, idhotel, role)
			VALUES ((SELECT * FROM participants AS id_part OFFSET i-1 LIMIT 1),
					starting_time, ending_time, week_day::weekday, hotel_id, rol_type);
		END LOOP;
		
	END LOOP;
END;
$$
LANGUAGE 'plpgsql';

--SELECT new_activities_data_3_5('2021-05-28 14:56:52', '2021-08-02 14:58:52', '200');
							
							
							
