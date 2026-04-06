-- Insert Student --
CREATE PROCEDURE "add_student" ("s_name" TEXT, "s_email" TEXT, "s_phone" TEXT, "dept_no" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if email already exists
    IF EXISTS (
        SELECT 1 FROM "student" WHERE "email" = s_email
    ) THEN
        RAISE EXCEPTION 'Student with this email already exists';
    END IF;
    -- Check if department exists
    IF NOT EXISTS (
        SELECT 1 FROM "department" WHERE "department_id" = dept_no
    ) THEN
        RAISE EXCEPTION 'Department does not exist';
    END IF;
    INSERT INTO "student" ("name", "email", "phone", "department_no")
    VALUES (s_name, s_email, s_phone, dept_no);
END;
$$;

-- Update Student --
CREATE PROCEDURE "update_student" ("s_id" INT, "s_name" TEXT, "s_email" TEXT, "s_phone" TEXT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if student exists
    IF NOT EXISTS (
        SELECT 1 FROM "student" WHERE "student_id" = s_id
    ) THEN
        RAISE EXCEPTION 'Student does not exist';
    END IF;
    -- Check if new email is taken by another student
    IF EXISTS (
        SELECT 1 FROM "student"
        WHERE "email" = s_email AND "student_id" != s_id
    ) THEN
        RAISE EXCEPTION 'Email is already used by another student';
    END IF;
    UPDATE "student"
    SET
        "name"  = s_name,
        "email" = s_email,
        "phone" = s_phone
    WHERE "student_id" = s_id;
END;
$$;

-- Delete Student --
CREATE PROCEDURE "delete_student" ("s_id" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if student exists
    IF NOT EXISTS (
        SELECT 1 FROM "student" WHERE "student_id" = s_id
    ) THEN
        RAISE EXCEPTION 'Student does not exist';
    END IF;
    DELETE FROM "student"
    WHERE "student"."student_id" = s_id;
END;
$$;

-- Assign Student To Track --
CREATE PROCEDURE "assign_student_to_track" ("s_id" INT, "t_id" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if student exists
    IF NOT EXISTS (
        SELECT 1 FROM "student" WHERE "student_id" = s_id
    ) THEN
        RAISE EXCEPTION 'Student does not exist';
    END IF;
    -- Check if track exists
    IF NOT EXISTS (
        SELECT 1 FROM "track" WHERE "track_id" = t_id
    ) THEN
        RAISE EXCEPTION 'Track does not exist';
    END IF;
    -- Check if already assigned
    IF EXISTS (
        SELECT 1 FROM "student_track"
        WHERE "student_id" = s_id AND "track_id" = t_id
    ) THEN
        RAISE EXCEPTION 'Student is already assigned to this track';
    END IF;
    INSERT INTO "student_track" ("student_id", "track_id")
    VALUES (s_id, t_id);
END;
$$;