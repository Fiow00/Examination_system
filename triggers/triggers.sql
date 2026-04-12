CREATE OR REPLACE FUNCTION "check_model_answer"()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM "choice"
        WHERE "choice_id" = NEW."correct_choice_id"
        AND "question_id" = NEW."question_id"
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

CREATE TRIGGER "check_student_answer_trigger"
BEFORE INSERT OR UPDATE ON "student_answer"
FOR EACH ROW
EXECUTE FUNCTION "check_student_answer"();


CREATE OR REPLACE FUNCTION "check_choices_count"()
RETURNS TRIGGER AS $$
DECLARE
    count INT;
    question_type TEXT;
BEGIN
    SELECT COUNT(*), "question"."type"
    INTO count, question_type
    FROM "choice"
    JOIN "question" ON "question"."question_id" = "choice"."question_id"
    WHERE "choice"."question_id" = NEW."question_id"
    GROUP BY "question"."type";

    IF count IS NULL THEN
        count := 0;
    END IF;

    count := count + 1;

    IF question_type = 'MCQ' AND count > 4 THEN
        RAISE EXCEPTION 'MCQ can not have more than 4 choices';
    ELSIF question_type = 'TF' AND count > 2 THEN
        RAISE EXCEPTION 'TF cannot have more than 2 choices';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE "plpgsql";

CREATE TRIGGER "check_choices_count_trigger"
BEFORE INSERT OR UPDATE ON "choice"
FOR EACH ROW
EXECUTE FUNCTION "check_choices_count"();