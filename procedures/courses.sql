-- Insert Course --
CREATE PROCEDURE "add_course" ("c_name" TEXT, "min_deg" INT, "max_deg" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    INSERT INTO "course" ("course_name", "min_degree", "max_degree")
    VALUES (c_name, min_deg, max_deg);
END;
$$;

-- Update Course --
CREATE PROCEDURE "update_course" ("c_id" INT, "c_name" TEXT, "min_deg" INT, "max_deg" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    UPDATE "course"
    SET "course_name" = c_name,
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
