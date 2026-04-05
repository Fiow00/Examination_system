-- Insert Instructor

CREATE OR REPLACE PROCEDURE add_instructor(i_name TEXT, i_email TEXT, d_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM instructor WHERE email = i_email) THEN
        RAISE EXCEPTION 'Instructor email already exists';
    END IF;

    IF d_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    INSERT INTO instructor (name, email, department_id)
    VALUES (i_name, i_email, d_id);
END;
$$;

--===============================================================
-- Update

CREATE OR REPLACE PROCEDURE update_instructor(i_id INT, i_name TEXT, i_email TEXT, d_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructor_id = i_id) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    IF EXISTS (SELECT 1 FROM instructor WHERE email = i_email AND instructor_id <> i_id) THEN
        RAISE EXCEPTION 'Instructor email already exists';
    END IF;

    IF d_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM department WHERE department_id = d_id) THEN
        RAISE EXCEPTION 'Department not found';
    END IF;

    UPDATE instructor
    SET name = i_name,
        email = i_email,
        department_id = d_id
    WHERE instructor_id = i_id;
END;
$$;


--================================================================================
--Delete

CREATE OR REPLACE PROCEDURE delete_instructor(i_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructor_id = i_id) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    DELETE FROM instructor
    WHERE instructor_id = i_id;
END;
$$;


--=====================================================================================
--Assign

CREATE OR REPLACE PROCEDURE assign_instructor_to_course(i_id INT, c_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM instructor WHERE instructor_id = i_id) THEN
        RAISE EXCEPTION 'Instructor not found';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM course WHERE course_id = c_id) THEN
        RAISE EXCEPTION 'Course not found';
    END IF;

    IF EXISTS (SELECT 1 FROM instructor_course WHERE instructor_id = i_id AND course_id = c_id) THEN
        RAISE EXCEPTION 'Instructor already assigned to this course';
    END IF;

    INSERT INTO instructor_course (instructor_id, course_id)
    VALUES (i_id, c_id);
END;
$$;




