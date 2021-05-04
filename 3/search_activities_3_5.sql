CREATE FUNCTION search_activities_3_5(hotel_id integer)
RETURNS TABLE(idhotel integer, starttime timestamp, endtime timestamp,
			  weekday weekday, activitytype activity_type,
			  reservedbyemployee integer)
AS
$$
BEGIN 
RETURN QUERY

--Return the activity info
SELECT act.*

--From the activities of this hotel
FROM (SELECT * FROM activity WHERE activity.idhotel = hotel_id) AS act

--Select all activities where there are no participants
LEFT JOIN (SELECT * FROM participates WHERE participates.idhotel = hotel_id) as part ON 
					part.starttime = act.starttime AND
					part.endtime = act.endtime AND part.weekday = act.weekday
WHERE part.starttime IS NULL;
END;
$$ LANGUAGE 'plpgsql' STABLE;

--SELECT * FROM search_activities_3_5('11')
