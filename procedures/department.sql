
-- Insert Department

CREATE OR REPLACE PROCEDURE add_department(d_name TEXT, d_location TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM department WHERE department_name = d_name) THEN
        RAISE EXCEPTION 'Department already exists';
    END IF;

    INSERT INTO department (department_name, location)
    VALUES (d_name, d_location);
END;
$$;

-- =========================
-- Update Department

CREATE OR REPLACE PROCEDURE update_department(d_id INT, d_name TEXT, d_location TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    IF EXISTS (SELECT 1 FROM department WHERE department_name = d_name AND department_id <> d_id) THEN
        RAISE EXCEPTION 'Department name already exists';
    END IF;

    UPDATE department
    SET department_name = d_name,
        location = d_location
    WHERE department_id = d_id;
END;
$$;

============================
-- Delete Department

CREATE OR REPLACE PROCEDURE delete_department(d_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    DELETE FROM department
    WHERE department_id = d_id;
END;
$$;

-- =========================
-- Select Department by ID

CREATE OR REPLACE FUNCTION get_department(d_id INT)
RETURNS TABLE (
    department_id INT,
    department_name TEXT,
    location TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT department_id, department_name, location
    FROM department
    WHERE department_id = d_id;
END;
$$;
