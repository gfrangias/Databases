CREATE FUNCTION double_to_month(double_type double precision)
RETURNS TABLE(month_type text)
AS
$$
DECLARE
	month_type text;
BEGIN 

RETURN QUERY
SELECT (CASE double_type WHEN '1' THEN 'January'
	WHEN '2' THEN 'February'
	WHEN '3' THEN 'March'
	WHEN '4' THEN 'April'
	WHEN '5' THEN 'May'
	WHEN '6' THEN 'June'
	WHEN '7' THEN 'July'
	WHEN '8' THEN 'August'
	WHEN '9' THEN 'September'
	WHEN '10' THEN 'October'
	WHEN '11' THEN 'November'
	WHEN '12' THEN 'December'
	ELSE 'Error'
END) AS Month;

END;
$$
LANGUAGE 'plpgsql' STABLE;

--SELECT double_to_month('12')