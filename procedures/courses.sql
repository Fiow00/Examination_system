-- Insert Course --
/**
 * add_course - Insert a new course into the database
 * 
 * Purpose: Create a new course with name, minimum degree, and maximum degree validation
 * 
 * Parameters:
 *   @name TEXT - Course name (required, 2-100 characters after trimming)
 *   @min_deg INT - Minimum passing degree (must be >= 0)
 *   @max_deg INT - Maximum possible degree (must be > min_deg)
 * 
 * Returns: None (raises NOTICE on success)
 * 
 * Exceptions:
 *   - 'Course name cannot be empty' - If name is NULL or blank
 *   - 'min_deg cannot be negative' - If min_deg < 0
 *   - 'max_degree must be greater than min_degree' - If max_deg <= min_deg
 *   - 'Course "%" already exists' - If course_name is not unique
 *   - 'Invalid course data (check name or degrees)' - If CHECK constraint violated
 * 
 * Supports: Arabic and English text (using ar_AR.utf8 collation)
 */
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
/**
 * update_course - Update an existing course's information
 * 
 * Purpose: Modify course name, minimum degree, and maximum degree with full validation
 * 
 * Parameters:
 *   @id INT - Course ID (must exist)
 *   @name TEXT - New course name (required, 2-100 characters after trimming)
 *   @min_deg INT - New minimum passing degree (must be >= 0)
 *   @max_deg INT - New maximum possible degree (must be > min_deg)
 * 
 * Returns: None (raises NOTICE on success)
 * 
 * Exceptions:
 *   - 'Course name cannot be empty' - If name is NULL or blank
 *   - 'min_degree cannot be negative' - If min_deg < 0
 *   - 'max_degree must be greater than min_degree' - If max_deg <= min_deg
 *   - 'Course with ID % does not exist' - If course_id not found
 *   - 'Course "%" already exists' - If new name conflicts with existing course
 *   - 'Invalid course data (check name or degrees)' - If CHECK constraint violated
 * 
 * Supports: Arabic and English text (using ar_AR.utf8 collation)
 */
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
        WHERE LOWER("course_name") COLLATE "ar_AR.utf8" = LOWER(clean_name) COLLATE "ar_AR.utf8"
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
/**
 * delete_course - Delete a course from the database with referential integrity checks
 * 
 * Purpose: Remove a course only if it has no dependencies (track_course, questions, exams)
 * 
 * Parameters:
 *   @id INT - Course ID (must exist and have no dependent records)
 * 
 * Returns: None (raises NOTICE on success)
 * 
 * Exceptions:
 *   - 'Course with ID % does not exist' - If course_id not found
 *   - 'Cannot delete course: it is assigned to a track' - If track_course dependency exists
 *   - 'Cannot delete course: it has related questions' - If question dependency exists
 *   - 'Cannot delete course: it has related exams' - If exam dependency exists
 * 
 * Note: Check foreign key constraints before deletion to prevent orphaned records
 */
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

    RAISE NOTICE 'Course with ID % deleted successfully', id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;

-- Select course by track --
/**
 * get_course_by_track - Retrieve all courses assigned to a specific track
 * 
 * Purpose: Query courses associated with a track for course management and exam generation
 * 
 * Parameters:
 *   @id INT - Track ID (must exist and have courses assigned)
 * 
 * Returns: Table with columns:
 *   - course_id INT - Course identifier
 *   - course_name TEXT - Course name (supports Arabic and English)
 *   - min_degree INT - Minimum passing degree
 *   - max_degree INT - Maximum possible degree
 * 
 * Exceptions:
 *   - 'Track with ID % does not exists' - If track_id not found (typo note: "exists")
 *   - 'No courses found for this track' - If track exists but has no courses
 * 
 * Supports: Arabic and English text (using ar_AR.utf8 collation)
 */
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
