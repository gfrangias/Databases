CREATE FUNCTION search_facility_subtypes_3_6(searched_facility character varying(45))
RETURNS TABLE("Facility_Name" character varying(45))
AS 
$$
BEGIN

-- If searched facility is not registered in the database
IF((SELECT count(*) FROM facility WHERE facility."nameFacility" = searched_facility) = 0) THEN
	RAISE EXCEPTION 'There is no facility "%" registered!', searched_facility;
END IF;

-- If searched facility is not first-level
IF((SELECT "subtypeOf" FROM facility WHERE facility."nameFacility" = searched_facility) IS NOT NULL
AND (SELECT "subtypeOf" FROM facility WHERE facility."nameFacility" = searched_facility) <>
  (SELECT "nameFacility" FROM facility WHERE facility."nameFacility" = searched_facility))THEN
	RAISE EXCEPTION 'Facility "%" is not first-level!', searched_facility;
END IF;


RETURN QUERY
-- Return all facilities that are subtypes of the searched facility
SELECT "nameFacility" FROM facility
WHERE facility."subtypeOf" = searched_facility AND facility."subtypeOf" <> facility."nameFacility";
END;
$$
LANGUAGE 'plpgsql';

--SELECT * FROM search_facility_subtypes_3_6('A');
--SELECT * FROM search_facility_subtypes_3_6('Fax');
--SELECT * FROM search_facility_subtypes_3_6('Kids Services');