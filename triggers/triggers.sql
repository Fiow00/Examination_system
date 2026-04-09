CREATE OR REPLACE FUNCTION "check_model_answer"()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM "choice"
        WHERE "choice_id" = NEW."correct_choice_id"
        ADD "question_id" = NEW."question_id"
    ) THEN
        RAISE EXCEPTION 'Correct choice must belong to the same question';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE "plpgsql";

CREATE TRIGGER "check_model_answer_trigger"
BEFORE INSERT OR UPDATE ON "model_answer"
FOR EACH ROW
EXECUTE FUNCTION "check_model_answer"();


CREATE OR REPLACE FUNCTION "check_student_answer"()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW."chosen_choice_id" IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM "choice"
        WHERE "choice_id" = NEW."chosen_choice_id"
        AND "question_id" = NEW."question_id"
    ) THEN
        RAISE EXCEPTION 'Invalid choice for this question';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE "plpgsql";

CREATE TRIGGER "check_student_answer"
BEFORE INSERT OR UPDATE ON "student_answer"
FOR EACH ROW
EXECUTE FUNCTION "check_student_answer"();
