-- Insert Course --
CREATE PROCEDURE "add_course" ("c_name" TEXT, "min_deg" INT, "max_deg" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check negative values
    IF "min_deg" < 0 
    THEN
        RAISE EXCEPTION "min_degree can not be negative";
    END IF;

    -- Check if max_degree less than min_degree
    IF "max_deg" <= "min_deg"
    THEN
        RAISE EXCEPTION "max_degree must be greated that min_degree";
    END IF;

    INSERT INTO "course" ("course_name", "min_degree", "max_degree")
    VALUES (c_name, min_deg, max_deg);
END;
$$;

-- Update Course --
CREATE PROCEDURE "update_course" ("c_id" INT, "c_name" TEXT, "min_deg" INT, "max_deg" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if old value does not exist
    IF NOT EXISTS (
        SELECT 1 FROM "course"
        WHERE "course_id" = c_id
    ) THEN
        RAISE EXCEPTION "course does not exist";
    END IF;

    -- Check negative values
    IF "min_deg" < 0
    THEN
        RAISE EXCEPTION "min_degree can no be negative";
    END IF;

    -- Check if max_degree less than min_degree
    IF "max_deg" <= "min_deg"
    THEN
        RAISE EXCEPTION "max_degree must be greater than min_dergee";
    END IF;

    UPDATE "course"
    SET 
        "course_name" = c_name,
        "min_degree" = min_deg,
        "max_degree" = max_deg
    WHERE "course_id" = c_id;
END;
$$;

-- Delete Course --
CREATE PROCEDURE "delete_course" ("c_name" TEXT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if old values does not exist
    IF NOT EXISTS (
        SELECT 1 FROM "course" WHERE "course_id" = c_id
    ) THEN
        RAISE EXCEPTION "Course does not exist"
    END IF;

    DELETE FROM "course"
    WHERE "course"."course_name" = c_name;
END;
$$;

-- Select course by track --
CREATE FUNCTION "get_by_track" ("t_id" INT)
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
        c."course_id",
        c."course_name",
        c."min_degree",
        c."max_degree"
    FROM "course" AS c
    WHERE c."course_id" IN (
        SELECT tc."course_id"
        FROM "track_course" AS tc
        WHERE tc."track_id" = t_id
    );
END;
$$;
