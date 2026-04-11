-- ========================================
-- Insert Instructor
CREATE OR REPLACE PROCEDURE add_instructor(
    instructor_name TEXT,
    instructor_email TEXT,
    department_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF instructor_name IS NULL OR TRIM(instructor_name) = '' THEN
        RAISE EXCEPTION 'Instructor name cannot be empty';
    END IF;

    IF instructor_email IS NULL OR TRIM(instructor_email) = '' THEN
        RAISE EXCEPTION 'Instructor email cannot be empty';
    END IF;

    IF EXISTS (
        SELECT 1 FROM instructor 
        WHERE email = instructor_email
    ) THEN
        RAISE EXCEPTION 'Instructor email already exists';
    END IF;

    IF department_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM department 
        WHERE department_id = department_id
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    INSERT INTO instructor (name, email, department_id)
    VALUES (instructor_name, instructor_email, department_id);
END;
$$;


-- ======================================================================
-- Update Instructor
CREATE OR REPLACE PROCEDURE update_instructor(
    instructor_id_param INT,
    instructor_name TEXT,
    instructor_email TEXT,
    department_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF instructor_name IS NULL OR TRIM(instructor_name) = '' THEN
        RAISE EXCEPTION 'Instructor name cannot be empty';
    END IF;

    IF instructor_email IS NULL OR TRIM(instructor_email) = '' THEN
        RAISE EXCEPTION 'Instructor email cannot be empty';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM instructor 
        WHERE instructor_id = instructor_id_param
    ) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM instructor 
        WHERE email = instructor_email 
        AND instructor_id <> instructor_id_param
    ) THEN
        RAISE EXCEPTION 'Instructor email already exists';
    END IF;

    IF department_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM department 
        WHERE department_id = department_id
    ) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    UPDATE instructor
    SET name = instructor_name,
        email = instructor_email,
        department_id = department_id
    WHERE instructor_id = instructor_id_param;
END;
$$;


-- ==============================================================================
-- Delete Instructor
CREATE OR REPLACE PROCEDURE delete_instructor(
    instructor_id_param INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM instructor 
        WHERE instructor_id = instructor_id_param
    ) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    DELETE FROM instructor
    WHERE instructor_id = instructor_id_param;
END;
$$;


-- ================================================================================
-- Assign Instructor To Course
CREATE OR REPLACE PROCEDURE assign_instructor_to_course(
    instructor_id_param INT,
    course_id_param INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM instructor 
        WHERE instructor_id = instructor_id_param
    ) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM course 
        WHERE course_id = course_id_param
    ) THEN
        RAISE EXCEPTION 'Course not found';
    END IF;

    IF EXISTS (
        SELECT 1 FROM instructor_course 
        WHERE instructor_id = instructor_id_param 
        AND course_id = course_id_param
    ) THEN
        RAISE EXCEPTION 'Instructor already assigned to this course';
    END IF;

    INSERT INTO instructor_course (instructor_id, course_id)
    VALUES (instructor_id_param, course_id_param);
END;
$$;
