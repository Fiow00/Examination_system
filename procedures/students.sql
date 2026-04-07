-- Insert Student 

CREATE OR REPLACE PROCEDURE "InsertStudent"("s_id" INT,"s_name" TEXT, "s_email" TEXT, "s_phone" TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "student" WHERE "email" = "s_email") THEN
        RAISE NOTICE 'User already exists.';
    ELSE
        INSERT INTO "student" ("name", "email", "phone")
        VALUES ("s_name", "s_email", "s_phone");
        RAISE NOTICE 'Student added successfully!';
    END IF;
END;
$$;
-- update student

CREATE OR REPLACE PROCEDURE "update_student" ("s_id" INT, "s_name" TEXT, "s_email" TEXT, "s_phone" TEXT)
LANGUAGE plpgsql
AS $$
BEGIN

    IF NOT EXISTS (SELECT 1 FROM "student" WHERE "student_id" = "s_id") THEN
        RAISE NOTICE 'Error: Student not found.';

    ELSIF EXISTS (SELECT 1 FROM "student" WHERE "email" = "s_email" AND "student_id" != "s_id") THEN
        RAISE NOTICE 'email is taken.';

    ELSE
        UPDATE "student"
        SET "name"  = "s_name",
            "email" = "s_email",
            "phone" = "s_phone"
        WHERE "student_id" = "s_id";
        
        RAISE NOTICE 'Student % updated successfully!', "s_id";
    END IF;
END;
$$;

-- Delete Student 

CREATE OR REPLACE PROCEDURE "delete_student"("s_id" INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Check if the student exists
    IF NOT EXISTS (SELECT 1 FROM "student" WHERE "student_id" = "s_id") THEN
        RAISE NOTICE 'Error: Student with ID % not found.', "s_id";
    
    -- 2. If they exist, delete them
    ELSE
        DELETE FROM "student" WHERE "student_id" = "s_id";
        RAISE NOTICE 'Student % deleted successfully!', "s_id";
    END IF;
END;
$$;

-- Assign Student To Track --

CREATE OR REPLACE PROCEDURE "assign_student_to_track"("s_id" INT, "t_id" INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- 1. Check if the Student and Track exist first
    IF NOT EXISTS (SELECT 1 FROM "student" WHERE "student_id" = "s_id") THEN
        RAISE NOTICE 'Error: Student ID % does not exist.', "s_id";
    
    ELSIF NOT EXISTS (SELECT 1 FROM "track" WHERE "track_id" = "t_id") THEN
        RAISE NOTICE 'Error: Track ID % does not exist.', "t_id";

    -- 2. Check if the student is already assigned to this track
    ELSIF EXISTS (SELECT 1 FROM "student_track" WHERE "student_id" = "s_id" AND "track_id" = "t_id") THEN
        RAISE NOTICE 'Notice: Student % is already in track %.', "s_id", "t_id";

    ELSE
        INSERT INTO "student_track" ("student_id", "track_id")
        VALUES ("s_id", "t_id");
        RAISE NOTICE 'Success: Student % assigned to Track %.', "s_id", "t_id";
    END IF;
END;
$$;