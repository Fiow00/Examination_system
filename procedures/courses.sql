-- Insert Course --
CREATE OR REPLACE PROCEDURE "add_course" (name TEXT, min_deg INT, max_deg INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check negative values
    IF min_deg < 0 THEN
        RAISE EXCEPTION 'Min_degree can not be negative (got: %)', min_deg;
    END IF;

    -- Check max degree > min degree
    IF max_deg <= min_deg THEN
        RAISE EXCEPTION 'Max_degree (%) must be greater than min_degree (%)', max_deg, min_deg;
    END IF;

    -- Check reasonable max
    IF max_deg > 100 THEN
        RAISE EXCEPTION 'Max_degree cannot exceed 100 (got: %)', max_deg;
    END IF;

    -- Check if empty
    IF TRIM(name) = '' THEN
        RAISE EXCEPTION 'Course name can not be empty';
    END IF;

    -- Check allowed characters (letters, numbers, spaces)
    IF TRIM(name) !~ '^[a-zA-Z0-9 ]+$' THEN
        RAISE EXCEPTION 'Course name contains invalid characters (only, letters, numbers, spaces)';
    END IF;

    -- Check at least one letter
    IF TRIM(name) !~ '[a-zA-Z]' THEN
        RAISE EXCEPTION 'Course name must contain at least one letter';
    END IF;

    -- Check if course already exist
    IF EXISTS (
        SELECT 1 FROM "course"
        WHERE LOWER("course_name") = LOWER(TRIM(name))
    ) THEN
        RAISE EXCEPTION 'Course "%" already exists', name;
    END IF;

    INSERT INTO "course" ("course_name", "min_degree", "max_degree")
    VALUES (LOWER(TRIM(name)), min_deg, max_deg);

    RAISE NOTICE 'Course "%" added successfully (min=%, max=%)', name, min_deg, max_deg;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;

-- Update Course --
CREATE PROCEDURE "update_course" (id INT, name TEXT, min_deg INT, max_deg INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if old value does not exist
    IF NOT EXISTS (
        SELECT 1 FROM "course"
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Course with ID % does not exist', id;
    END IF;

    -- Check negative values
    IF min_deg < 0
    THEN
        RAISE EXCEPTION 'min_degree can no be negative';
    END IF;

    -- Check if max_degree less than min_degree
    IF max_deg <= min_deg
    THEN
        RAISE EXCEPTION 'max_degree must be greater than min_dergee';
    END IF;

    UPDATE "course"
    SET 
        "course_name" = name,
        "min_degree" = min_deg,
        "max_degree" = max_deg
    WHERE "course_id" = id;
END;
$$;

-- Delete Course --
CREATE PROCEDURE "delete_course" (id INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if old values does not exist
    IF NOT EXISTS (
        SELECT 1 FROM "course" WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Course does not exist';
    END IF;

    DELETE FROM "course"
    WHERE "course_id" = id;
END;
$$;

-- Select course by track --
CREATE FUNCTION "get_course_by_track" (id INT)
RETURNS TABLE (
    "course_id" INT,
    "course_name" TEXT,
    "min_degree" INT,
    "max_degree" INT
)
LANGUAGE "plpgsql"
AS $$
BEGIN
    RETURN QUERY
    SELECT
        "course"."course_id",
        "course"."course_name",
        "course"."min_degree",
        "course"."max_degree"
    FROM "course"
    JOIN "track_course" ON "course"."course_id" = "track_course"."course_id"
    WHERE "track_course"."track_id" = id;
END;
$$;
