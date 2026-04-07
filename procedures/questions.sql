-- Insert Question --
CREATE PROCEDURE "add_question" ("c_id" INT, "q_text" TEXT, "q_type" TEXT, "q_points" INT, "q_options" TEXT[], "correct_index" INT)
LANGUAGE "plpgsql"
AS $$
DECLARE
    "v_question_id"    INT;
    "v_option_id"      INT;
    "v_correct_opt_id" INT;
    "v_expected_count" INT;
    "i"                INT;
BEGIN
    -- Check if course exists
    IF NOT EXISTS (
        SELECT 1 FROM "course" WHERE "course_id" = c_id
    ) THEN
        RAISE EXCEPTION 'Course does not exist';
    END IF;
    -- Check question type
    IF "q_type" NOT IN ('MCQ', 'TF')
    THEN
        RAISE EXCEPTION 'Question type must be MCQ or TF';
    END IF;
    -- Check option count matches type
    "v_expected_count" := CASE q_type WHEN 'MCQ' THEN 4 ELSE 2 END;
    IF array_length(q_options, 1) != "v_expected_count"
    THEN
        RAISE EXCEPTION 'MCQ requires 4 options and TF requires 2 options';
    END IF;
    -- Check correct index is valid
    IF "correct_index" < 1 OR "correct_index" > "v_expected_count"
    THEN
        RAISE EXCEPTION 'correct_index is out of range';
    END IF;
    -- Insert question
    INSERT INTO "question" ("course_id", "question_text", "type", "points")
    VALUES (c_id, q_text, q_type, q_points)
    RETURNING "question_id" INTO "v_question_id";
    -- Insert options
    FOR i IN 1 .. "v_expected_count" LOOP
        INSERT INTO "choice" ("question_id", "option_text", "option_order")
        VALUES ("v_question_id", q_options[i], i)
        RETURNING "option_id" INTO "v_option_id";
        -- Save the correct option id
        IF i = "correct_index"
        THEN
            "v_correct_opt_id" := "v_option_id";
        END IF;
    END LOOP;
    -- Insert model answer
    INSERT INTO "model_answer" ("question_id", "correct_option_id")
    VALUES ("v_question_id", "v_correct_opt_id");
END;
$$;

-- Update Question --
CREATE PROCEDURE "update_question" ("q_id" INT, "q_text" TEXT, "q_points" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if question exists
    IF NOT EXISTS (
        SELECT 1 FROM "question" WHERE "question_id" = q_id
    ) THEN
        RAISE EXCEPTION 'Question does not exist';
    END IF;
    -- Check points is not negative
    IF "q_points" < 0
    THEN
        RAISE EXCEPTION 'Points cannot be negative';
    END IF;
    UPDATE "question"
    SET
        "question_text" = q_text,
        "points"        = q_points
    WHERE "question_id" = q_id;
END;
$$;

-- Delete Question --
CREATE PROCEDURE "delete_question" ("q_id" INT)
LANGUAGE "plpgsql"
AS $$
BEGIN
    -- Check if question exists
    IF NOT EXISTS (
        SELECT 1 FROM "question" WHERE "question_id" = q_id
    ) THEN
        RAISE EXCEPTION 'Question does not exist';
    END IF;
    -- Check if question is used in an exam
    IF EXISTS (
        SELECT 1 FROM "exam_question" WHERE "question_id" = q_id
    ) THEN
        RAISE EXCEPTION 'Cannot delete question that is used in an exam';
    END IF;
    DELETE FROM "question"
    WHERE "question"."question_id" = q_id;
END;
$$;