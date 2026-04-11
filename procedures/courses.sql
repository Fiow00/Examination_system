-- Insert Course --
CREATE OR REPLACE PROCEDURE "add_course" (name TEXT, min_deg INT, max_deg INT)
LANGUAGE "plpgsql"
AS $$
DECLARE 
    clean_name TEXT := TRIM(name);
BEGIN

    IF name IS NULL OR clean_name = '' THEN
        RAISE EXCEPTION 'Course name cannot be empty';
    END IF;

    IF min_deg < 0 THEN
        RAISE EXCEPTION 'min_deg cannot be negative';
    END IF;

    IF max_deg <= min_deg THEN
        RAISE EXCEPTION 'max_degree must be greater than min_degree';
    END IF;

    INSERT INTO "course" ("course_name", "min_degree", "max_degree")
    VALUES (clean_name, min_deg, max_deg);

    RAISE NOTICE 'Course "%" added successfully (min=%, max=%)', clean_name, min_deg, max_deg;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Course "%" already exists', clean_name;

    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid course data (check name or degrees)';

    WHEN OTHERS THEN
        RAISE;
END;
$$;

-- Update Course --
CREATE PROCEDURE "update_course" (id INT, name TEXT, min_deg INT, max_deg INT)
LANGUAGE "plpgsql"
AS $$
DECLARE
    clean_name TEXT := TRIM(name);
BEGIN

    IF name IS NULL OR clean_name = '' THEN
        RAISE EXCEPTION 'Course name cannot be empty';
    END IF;

    IF min_deg < 0 THEN
        RAISE EXCEPTION 'min_degree cannot be negative';
    END IF;

    IF max_deg <= min_deg THEN
        RAISE EXCEPTION 'max_degree must be greater than min_degree';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM "course"
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Course with ID % does not exist', id;
    END IF;

    IF EXISTS (
        SELECT 1 FROM "course"
        WHERE LOWER("course_name") = LOWER(clean_name)
        AND "course_id" <> id
    ) THEN
        RAISE EXCEPTION 'Course "%" already exists', clean_name;
    END IF;

    UPDATE "course"
    SET 
        "course_name" = clean_name,
        "min_degree" = min_deg,
        "max_degree" = max_deg
    WHERE "course_id" = id;

    RAISE NOTICE 'Course "%" updated successfully (id=%)', clean_name, id;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Course "%" already exists', clean_name;
    WHEN check_violation THEN
        RAISE EXCEPTION 'Invalid course data (check name or degrees)';
    WHEN OTHERS THEN
        RAISE;
END;
$$;

-- Delete Course --
CREATE PROCEDURE "delete_course" (id INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if course exists
    IF NOT EXISTS (
        SELECT 1 FROM "course" 
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Course with ID % does not exist', id;
    END IF;

    -- Check if course is used in track_course
    IF EXISTS (
        SELECT 1 FROM "track_course"
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Cannot delete course: it is assigned to a track';
    END IF;

    -- Check if course has questions
    IF EXISTS (
        SELECT 1 FROM "question"
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Cannot delete course: it has related questions';
    END IF;

    -- Check if course has exams
    IF EXISTS (
        SELECT 1 FROM "exam"
        WHERE "course_id" = id
    ) THEN
        RAISE EXCEPTION 'Cannot delete course: it has related exams';
    END IF;

    DELETE FROM "course"
    WHERE "course_id" = id;

    RAISE NOTICE 'Course with ID % deleted successfullly', id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
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
    IF NOT EXISTS (
        SELECT 1 FROM "track" WHERE "track_id" = id
    ) THEN
        RAISE EXCEPTION 'Track with ID % does not exists', id;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM "track_course"
        WHERE "track_id" = id
    ) THEN
        RAISE EXCEPTION 'No courses found for this track';
    END IF;

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
