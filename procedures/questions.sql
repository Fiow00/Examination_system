-- Insert Question 
CREATE OR REPLACE PROCEDURE "InsertQuestion"(
    "p_course_id" INT, 
    "p_text" TEXT, 
    "p_type" TEXT, 
    "p_points" INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "question" ("course_id", "question_body", "type", "points")
    VALUES ("p_course_id", "p_text", "p_type", "p_points");

    RAISE NOTICE 'Question added successfully!';

EXCEPTION
    -- 1. if the Course ID doesn't exist 
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Error: Course ID % not found.', "p_course_id";

    -- 2.  if the Type is wrong 
    WHEN check_violation THEN
        RAISE NOTICE 'Error: Type must be MCQ or TF.';
END;
$$;
-- Update Question 

CREATE OR REPLACE PROCEDURE "UpdateQuestion"(
    "p_q_id" INT, 
    "p_text" TEXT, 
    "p_points" INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "question"
    SET "question_body" = "p_text",
        "points" = "p_points"
    WHERE "question_id" = "p_q_id";

    -- FOUND is for if the question_id exists already
    IF FOUND THEN
        RAISE NOTICE 'Question % updated successfully', "p_q_id";
    ELSE
        RAISE NOTICE 'Error: Question % not found', "p_q_id";
    END IF;

EXCEPTION
    -- check the "points > 0" violation from  schema
    WHEN check_violation THEN
        RAISE NOTICE 'Error: Points must be greater than zero.';
END;
$$;
-- Delete Question --
CREATE OR REPLACE PROCEDURE "delete_question" ("q_id" INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM "question" WHERE "question_id" = "q_id";

    IF NOT FOUND THEN
        RAISE NOTICE 'Question does not exist.';
    ELSE
        RAISE NOTICE 'Question and its choices deleted successfully.';
    END IF;

EXCEPTION
    -- 3. check the case where the question is tied to an exam
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Error: Cannot delete question % because it is currently used in an exam.', "q_id";
END;
$$;