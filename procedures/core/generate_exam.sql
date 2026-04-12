/**
 * generate_exam - Generate a randomized exam for a course
 * 
 * Purpose: Create a new exam by randomly selecting MCQ and True/False questions from the course's question bank.
 *          Each exam instance contains unique questions with no duplicates.
 * 
 * Parameters:
 *   @p_course_id INT - Target course ID (must exist)
 *   @p_exam_name TEXT - Exam name (required, unique per course, supports Arabic and English)
 *   @p_num_mcq INT - Number of MCQ questions to include (must be >= 0 and available)
 *   @p_num_tf INT - Number of True/False questions to include (must be >= 0 and available)
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
    p_course_id INT,
    p_exam_name TEXT,
    p_num_mcq INT,
    p_num_tf INT
)
LANGUAGE "plpgsql"
AS $$
DECLARE
    total_questions INT;
    v_exam_id INT;
BEGIN
    total_questions := p_num_mcq + p_num_tf;

    IF NOT EXISTS (
        SELECT 1 FROM "course"
        WHERE "course_id" = p_course_id
    ) THEN
        RAISE EXCEPTION 'Course with ID % does not exist', p_course_id;
    END IF;

    IF p_exam_name IS NULL OR TRIM(p_exam_name) = '' THEN
        RAISE EXCEPTION 'Exam name cannot be empty';
    END IF;

    IF p_num_mcq < 0 OR p_num_tf < 0 THEN
        RAISE EXCEPTION 'Number of questions cannot be negative';
    END IF;

    IF total_questions = 0 THEN
        RAISE EXCEPTION 'Total questions must be greater than 0';
    END IF;

    IF EXISTS (
        SELECT 1 FROM "exam"
        WHERE LOWER("name") = LOWER(TRIM(p_exam_name))
        AND "course_id" = p_course_id
    ) THEN
        RAISE EXCEPTION 'Exam "%" already exists for this course', p_exam_name;
    END IF;

    IF (
        SELECT COUNT(*)
        FROM "question"
        JOIN "model_answer" USING ("question_id")
        WHERE "course_id" = p_course_id
        AND "type" = 'MCQ'
    ) < p_num_mcq THEN
        RAISE EXCEPTION 'Not enough MCQ questions for this course';
    END IF;

    IF (
        SELECT COUNT(*)
        FROM "question"
        JOIN "model_answer" USING ("question_id")
        WHERE "course_id" = p_course_id
        AND "type" = 'TF'
    ) < p_num_tf THEN
        RAISE EXCEPTION 'Not enough TF questions for this course';
    END IF;

    INSERT INTO "exam" ("name", "course_id", "total_questions")
    VALUES (TRIM(p_exam_name), p_course_id, total_questions)
    RETURNING "exam_id" INTO v_exam_id;

    INSERT INTO "exam_question" ("exam_id", "question_id", "order_number")
    SELECT 
        v_exam_id,
        q."question_id",
        ROW_NUMBER() OVER ()
    FROM (
        SELECT "question_id"
        FROM "question"
        JOIN "model_answer" USING ("question_id")
        WHERE "course_id" = p_course_id
        AND "type" = 'MCQ'
        ORDER BY RANDOM()
        LIMIT p_num_mcq
    ) q;

    INSERT INTO "exam_question" ("exam_id", "question_id", "order_number")
    SELECT 
        v_exam_id,
        q."question_id",
        ROW_NUMBER() OVER () + p_num_mcq
    FROM (
        SELECT "question_id"
        FROM "question"
        JOIN "model_answer" USING ("question_id")
        WHERE "course_id" = p_course_id
        AND "type" = 'TF'
        ORDER BY RANDOM()
        LIMIT p_num_tf
    ) q;

    RAISE NOTICE 'Exam "%" created successfully with % questions', p_exam_name, total_questions;

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Exam "%" already exists for this course', p_exam_name;

    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'Invalid course reference';

    WHEN OTHERS THEN
        RAISE;
END;
$$;