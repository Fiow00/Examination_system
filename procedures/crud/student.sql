-- Insert Student 

CREATE OR REPLACE PROCEDURE insert_student(s_name TEXT, s_email TEXT, s_phone TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO student (name, email, phone)
    VALUES (s_name, s_email, s_phone)
    ON CONFLICT (email) DO NOTHING;

    IF FOUND THEN
        RAISE NOTICE 'Student added successfully!';
    ELSE
        RAISE NOTICE 'User exists';
    END IF;
END;
$$;
-- update student

CREATE OR REPLACE PROCEDURE update_student(s_id INT, s_name TEXT, s_email TEXT, s_phone TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO student (student_id, name, email, phone)
    VALUES (s_id, s_name, s_email, s_phone)
    ON CONFLICT (student_id) 
    DO UPDATE SET 
        name = EXCLUDED.name,
        email = EXCLUDED.email,
        phone = EXCLUDED.phone;

    RAISE NOTICE 'Student Updated).';
END;
$$;
-- Delete Student 

CREATE OR REPLACE PROCEDURE delete_student(s_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM student WHERE student_id = s_id;

    -- FOUND is a built-in boolean 
    IF FOUND THEN
        RAISE NOTICE 'Student deleted successfully!';
    ELSE
        RAISE NOTICE 'Student not found.';
    END IF;
END;
$$;

-- Assign Student To Track --

CREATE OR REPLACE PROCEDURE assign_student_to_track(s_id INT, t_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO student_track (student_id, track_id)
    VALUES (s_id, t_id)
    ON CONFLICT (student_id, track_id) DO NOTHING;

    IF FOUND THEN
        RAISE NOTICE 'Student assigned to Track.';
    ELSE
        RAISE NOTICE 'Student already in track.';
    END IF;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Error: Either Student ID % or Track ID % does not exist.', s_id, t_id;
END;
$$;