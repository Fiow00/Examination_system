 CREATE OR REPLACE PROCEDURE SubmitExamAnswers(
    p_student_id INT,
    p_exam_id INT,
    p_start_time TIMESTAMP WITH TIME ZONE,
    p_end_time TIMESTAMP WITH TIME ZONE,
    p_answers JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_student_exam_id INT;
BEGIN

   
    IF NOT EXISTS (
        SELECT 1 FROM student 
        WHERE student_id = p_student_id
    ) THEN
        RAISE EXCEPTION 'Student not found';
    END IF;

  
    IF NOT EXISTS (
        SELECT 1 FROM exam 
        WHERE exam_id = p_exam_id
    ) THEN
        RAISE EXCEPTION 'Exam not found';
    END IF;

     
    IF p_end_time <= p_start_time THEN
        RAISE EXCEPTION 'End time must be after start time';
    END IF;

    
    IF p_answers IS NULL OR jsonb_array_length(p_answers) = 0 THEN
        RAISE EXCEPTION 'Answers cannot be empty';
    END IF;

   
    INSERT INTO student_exam (student_id, exam_id, start_time, end_time)
    VALUES (p_student_id, p_exam_id, p_start_time, p_end_time)
    RETURNING student_exam_id INTO v_student_exam_id;

    
    IF EXISTS (
        SELECT 1
        FROM jsonb_array_elements(p_answers) AS elem
        WHERE NOT EXISTS (
            SELECT 1 FROM exam_question eq
            WHERE eq.exam_id = p_exam_id
            AND eq.question_id = (elem->>'question_id')::INT
        )
    ) THEN
        RAISE EXCEPTION 'One or more questions do not belong to this exam';
    END IF;

     
    IF EXISTS (
        SELECT 1
        FROM jsonb_array_elements(p_answers) AS elem
        WHERE NOT EXISTS (
            SELECT 1 FROM choice c
            WHERE c.choice_id = (elem->>'chosen_option_id')::INT
            AND c.question_id = (elem->>'question_id')::INT
        )
    ) THEN
        RAISE EXCEPTION 'Invalid choice for this question';
    END IF;

    
    IF EXISTS (
        SELECT question_id
        FROM (
            SELECT (elem->>'question_id')::INT AS question_id
            FROM jsonb_array_elements(p_answers) AS elem
        ) t
        GROUP BY question_id
        HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Duplicate answers for same question';
    END IF;

    
    INSERT INTO student_answer (student_exam_id, question_id, chosen_choice_id)
    SELECT 
        v_student_exam_id,
        (elem->>'question_id')::INT,
        (elem->>'chosen_option_id')::INT
    FROM jsonb_array_elements(p_answers) AS elem;

END;
$$;