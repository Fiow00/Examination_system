--Department procedures
--Drop
 DROP PROCEDURE IF EXISTS insertdepartment(text, text);
 DROP FUNCTION IF EXISTS SelectDepartments();
DROP PROCEDURE IF EXISTS DeleteDepartment(INT);
DROP PROCEDURE IF EXISTS UpdateDepartment(INT, TEXT, TEXT);

--insert

CREATE OR REPLACE PROCEDURE InsertDepartment(
    p_department_name TEXT,
    p_location TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN

     IF p_department_name IS NULL OR TRIM(p_department_name) = '' THEN
        RAISE EXCEPTION 'Department name cannot be empty';
    END IF;
	IF p_location IS NULL OR TRIM(p_location) = '' THEN
        RAISE EXCEPTION 'Location cannot be empty';
    END IF;

     IF EXISTS (
        SELECT 1 FROM "department"
        WHERE LOWER("department_name") = LOWER(p_department_name)
		AND LOWER("location") = LOWER(p_location)
    ) THEN
        RAISE EXCEPTION 'Department already exists';
    END IF;

    
    INSERT INTO "department" ("department_name", "location")
    VALUES (p_department_name, p_location);

END;
$$;

--update
CREATE OR REPLACE PROCEDURE UpdateDepartment(
    p_department_id INT,
    p_department_name TEXT,
    p_location TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN

     IF NOT EXISTS (
        SELECT 1 FROM "department"
        WHERE "department_id" = p_department_id
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

   
    IF p_department_name IS NULL OR TRIM(p_department_name) = '' THEN
        RAISE EXCEPTION 'Department name cannot be empty';
    END IF;
	
	IF p_location IS NULL OR TRIM(p_location) = '' THEN
    RAISE EXCEPTION 'Location cannot be empty';
    END IF;
 
    IF EXISTS (
        SELECT 1 FROM "department"
        WHERE LOWER("department_name") = LOWER(p_department_name)
		  AND LOWER("location") = LOWER(p_location)
        AND "department_id" <> p_department_id
    ) THEN
        RAISE EXCEPTION 'Another department with same name exists';
    END IF;

    
    UPDATE "department"
    SET 
        "department_name" = p_department_name,
        "location" = p_location
    WHERE "department_id" = p_department_id;

END;
$$;

---delete
CREATE OR REPLACE PROCEDURE DeleteDepartment(
    p_department_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN

     IF NOT EXISTS (
        SELECT 1 FROM "department"
        WHERE "department_id" = p_department_id
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    
    DELETE FROM "department"
    WHERE "department_id" = p_department_id;

END;
$$;


--Select function
CREATE OR REPLACE FUNCTION SelectDepartments()
RETURNS TABLE(
    department_id INT,
    department_name TEXT,
    location TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d."department_id",
        d."department_name",
        d."location"
    FROM "department" d
    ORDER BY d."department_id";
END;
$$;



