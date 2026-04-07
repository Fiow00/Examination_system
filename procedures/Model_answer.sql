CREATE OR REPLACE PROCEDURE SetModelAnswer(
    p_question_id INT,
    p_correct_choice_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN

     IF NOT EXISTS (
        SELECT 1 FROM "question"
        WHERE "question_id" = p_question_id
    ) THEN
        RAISE EXCEPTION 'Question with ID % not found', p_question_id;
    END IF;

     IF NOT EXISTS (
        SELECT 1 FROM "choice"
        WHERE "choice_id" = p_correct_choice_id
    ) THEN
        RAISE EXCEPTION 'Choice with ID % not found', p_correct_choice_id;
    END IF;

     IF NOT EXISTS (
        SELECT 1 FROM "choice"
        WHERE "choice_id" = p_correct_choice_id
        AND "question_id" = p_question_id
    ) THEN
        RAISE EXCEPTION 'Choice does not belong to this question';
    END IF;

     IF EXISTS (
        SELECT 1 FROM "model_answer"
        WHERE "question_id" = p_question_id
    ) THEN

        UPDATE "model_answer"
        SET "correct_choice_id" = p_correct_choice_id
        WHERE "question_id" = p_question_id;

    ELSE

        INSERT INTO "model_answer" ("question_id", "correct_choice_id")
        VALUES (p_question_id, p_correct_choice_id);

    END IF;

END;
$$;