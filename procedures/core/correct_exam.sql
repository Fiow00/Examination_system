
-- Correct Exam Procedure

CREATE OR REPLACE PROCEDURE correct_exam(
    student_exam_id_input INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    calculated_total_grade INT := 0;
BEGIN

    -- =================================================================================
    -- Validation: StudentExam ID

    IF student_exam_id_input IS NULL OR student_exam_id_input <= 0 THEN
        RAISE EXCEPTION 'StudentExamID cannot be null or invalid';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM student_exam
        WHERE student_exam_id = student_exam_id_input
    ) THEN
        RAISE EXCEPTION 'Student exam not found';
    END IF;

    -- =====================================================================================
    -- Calculate Total Grade

    SELECT COALESCE(SUM(
        CASE 
            WHEN model_answer.correct_choice_id = student_answer.chosen_choice_id
            THEN question.points
            ELSE 0
        END
    ), 0)
    INTO calculated_total_grade
    FROM student_answer
    JOIN question 
        ON question.question_id = student_answer.question_id
    LEFT JOIN model_answer 
        ON model_answer.question_id = student_answer.question_id
    WHERE student_answer.student_exam_id = student_exam_id_input;

    -- =================================================================
    -- Update Student Exam Result

    UPDATE student_exam
    SET total_grade = calculated_total_grade
    WHERE student_exam_id = student_exam_id_input;

END;
$$;
