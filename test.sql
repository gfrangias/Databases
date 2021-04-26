CREATE OR REPLACE FUNCTION concat(fname character varying(45), lname character varying(45))
RETURNS character(90) AS
$$
BEGIN
RETURN CONCAT(lname, fname);
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

SELECT concat('Chatzis','Thomas')