/**
 * generate_exam - Generate a randomized exam for a course
 * 
 * Purpose: Create a new exam by randomly selecting MCQ and True/False questions from the course's question bank.
 *          Each exam instance contains unique questions with no duplicates.
 * 
 * Parameters:
 *   @course_id INT - Target course ID (must exist)
 *   @exam_name TEXT - Exam name (required, unique per course, supports Arabic and English)
 *   @num_mcq INT - Number of MCQ questions to include (must be >= 0 and available)
 *   @num_tf INT - Number of True/False questions to include (must be >= 0 and available)
 * 
 * Returns: None (raises NOTICE on success, creates exam and exam_question records)
 * 
 * Exceptions:
 *   - 'Course with ID % does not exist' - If course_id not found
 *   - 'Exam name cannot be empty' - If exam_name is NULL or blank
 *   - 'Number of questions cannot be negative' - If num_mcq or num_tf < 0
 *   - 'Total questions must be greater than 0' - If num_mcq + num_tf = 0
 *   - 'Exam "%" already exists for this course' - If exam_name is not unique per course
 *   - 'Not enough MCQ questions for this course' - If insufficient MCQ questions available
 *   - 'Not enough TF questions for this course' - If insufficient TF questions available
 *   - 'Invalid course reference' - On foreign key violation
 * 
 * Performance: NFR-01 - Exam generation (up to 50 questions) < 2 seconds
 * 
 * Notes:
 *   - All questions must have a model_answer (correct choice) to be eligible for selection
 *   - Questions are selected randomly without duplicates
 *   - Exam names are trimmed to preserve case for Arabic/English text support (ar_AR.utf8 collation)
 * 
 * Supports: Arabic and English text via ar_AR.utf8 collation
 */
CREATE OR REPLACE PROCEDURE "generate_exam"(
    course_id INT,
    exam_name TEXT,
    num_mcq INT,
    num_tf INT
)
LANGUAGE "plpgsql"
AS $$
DECLARE
    total_questions INT;
    exam_id INT;
BEGIN

    total_questions := num_mcq + num_tf;

    IF NOT EXISTS (
        SELECT 1 FROM "course"
        WHERE "course"."course_id" = course_id
    ) THEN
        RAISE EXCEPTION 'Course with ID % does not exist', course_id;
    END IF;

    IF TRIM(exam_name) = '' THEN
        RAISE EXCEPTION 'Exam name cannot be empty';
    END IF;

    IF num_mcq < 0 OR num_tf < 0 THEN
        RAISE EXCEPTION 'Number of questions cannot be negative';
    END IF;

    IF total_questions = 0 THEN
        RAISE EXCEPTION 'Total questions must be greater than 0';
    END IF;

    IF EXISTS (
        SELECT 1 FROM "exam"
        WHERE LOWER("name") = LOWER(TRIM(exam_name))
        AND "exam"."course_id" = course_id
    ) THEN
        RAISE EXCEPTION 'Exam "%" already exists for this course', exam_name;
    END IF;

    IF (
        SELECT COUNT(*)
        FROM "question"
        JOIN "model_answer" ON "question"."question_id" = "model_answer"."question_id"
        WHERE "question"."course_id" = course_id
        AND "question"."type" = 'MCQ'
    ) < num_mcq THEN
        RAISE EXCEPTION 'Not enough MCQ questions for this course';
    END IF;

    IF (
        SELECT COUNT(*)
        FROM "question"
        JOIN "model_answer" ON "question"."question_id" = "model_answer"."question_id"
        WHERE "question"."course_id" = course_id
        AND "question"."type" = 'TF'
    ) < num_tf THEN
        RAISE EXCEPTION 'Not enough TF questions for this course';
    END IF;

    INSERT INTO "exam" ("name", "course_id", "total_questions")
    VALUES (TRIM(exam_name), course_id, total_questions)
    RETURNING "exam_id" INTO exam_id;

    INSERT INTO "exam_question" ("exam_id", "question_id", "order_number")
    SELECT 
        exam_id,
        "question"."question_id",
        ROW_NUMBER() OVER ()
    FROM (
        SELECT "question"."question_id"
        FROM "question"
        JOIN "model_answer" ON "question"."question_id" = "model_answer"."question_id"
        WHERE "question"."course_id" = course_id
        AND "question"."type" = 'MCQ'
        ORDER BY RANDOM()
        LIMIT num_mcq
    ) AS mcq_questions;

    INSERT INTO "exam_question" ("exam_id", "question_id", "order_number")
    SELECT 
        exam_id,
        "question"."question_id",
        ROW_NUMBER() OVER () + num_mcq
    FROM (
        SELECT "question"."question_id"
        FROM "question"
        JOIN "model_answer" ON "question"."question_id" = "model_answer"."question_id"
        WHERE "question"."course_id" = course_id
        AND "question"."type" = 'TF'
        ORDER BY RANDOM()
        LIMIT num_tf
    ) AS tf_questions;

    RAISE NOTICE 'Exam "%" created successfully with % questions', exam_name, total_questions;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Exam "%" already exists for this course', exam_name;

    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Invalid course reference';

    WHEN OTHERS THEN
        RAISE;
END;
$$;