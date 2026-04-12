-- ========================================
-- Insert Track
CREATE OR REPLACE PROCEDURE add_track(
    track_name TEXT,
    department_id_input INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF track_name IS NULL OR TRIM(track_name) = '' THEN
        RAISE EXCEPTION 'Track name cannot be empty';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM department 
        WHERE department_id = department_id_input
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM track 
        WHERE track_name = track_name 
        AND department_id = department_id_input
    ) THEN
        RAISE EXCEPTION 'Track already exists in this department';
    END IF;

    INSERT INTO track (track_name, department_id)
    VALUES (track_name, department_id_input);
END;
$$;


-- ====================================================================
-- Update Track
CREATE OR REPLACE PROCEDURE update_track(
    track_id INT,
    track_name TEXT,
    department_id_input INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF track_name IS NULL OR TRIM(track_name) = '' THEN
        RAISE EXCEPTION 'Track name cannot be empty';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM track 
        WHERE track_id = track_id
    ) THEN
        RAISE EXCEPTION 'Track not found';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM department 
        WHERE department_id = department_id_input
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM track 
        WHERE track_name = track_name 
        AND department_id = department_id_input 
        AND track_id <> track_id
    ) THEN
        RAISE EXCEPTION 'Track name already exists in this department';
    END IF;

    UPDATE track
    SET track_name = track_name,
        department_id = department_id_input
    WHERE track_id = track_id;
END;
$$;


-- =============================================================================
-- Delete Track
CREATE OR REPLACE PROCEDURE delete_track(
    track_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (
        SELECT 1 FROM track 
        WHERE track_id = track_id
    ) THEN
        RAISE EXCEPTION 'Track not found';
    END IF;

    DELETE FROM track
    WHERE track_id = track_id;
END;
$$;


-- ==============================================================================
-- Select Tracks by Department
CREATE OR REPLACE FUNCTION get_tracks_by_department(
    department_id_input INT
)
RETURNS TABLE (
    track_id INT,
    track_name TEXT,
    department_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT track_id, track_name, department_id
    FROM track
    WHERE department_id = department_id_input;
END;
$$;
