
-- Insert Track

CREATE OR REPLACE PROCEDURE add_track(t_name TEXT, d_id INT)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;


    IF EXISTS (
        SELECT 1 FROM track WHERE track_name = t_name AND department_id = d_id
    ) THEN
        RAISE EXCEPTION 'Track already exists in this department';
    END IF;

    INSERT INTO track (track_name, department_id)
    VALUES (t_name, d_id);
END;
$$;

-- =================================================================================
-- Update

CREATE OR REPLACE PROCEDURE update_track(t_id INT, t_name TEXT, d_id INT)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (SELECT 1 FROM track WHERE track_id = t_id) THEN
        RAISE EXCEPTION 'Track not found';
    END IF;


    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;


    IF EXISTS (
        SELECT 1 FROM track WHERE track_name = t_name AND department_id = d_id AND track_id <> t_id
    ) THEN
        RAISE EXCEPTION 'Track name already exists in this department';
    END IF;

    UPDATE track
    SET track_name = t_name,
        department_id = d_id
    WHERE track_id = t_id;
END;
$$;

-- ===================================================================================================
-- Delete

CREATE OR REPLACE PROCEDURE delete_track(t_id INT)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (SELECT 1 FROM track WHERE track_id = t_id) THEN
        RAISE EXCEPTION 'Track not found';
    END IF;

    DELETE FROM track
    WHERE track_id = t_id;
END;
$$;

-- ===============================================================================================
-- Select Tracks by Department
CREATE OR REPLACE FUNCTION get_tracks_by_department(d_id INT)
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
    WHERE department_id = d_id;
END;
$$;
