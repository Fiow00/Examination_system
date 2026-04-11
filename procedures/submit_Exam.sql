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

       
    IF p_end_time <= p_start_time THEN
        RAISE EXCEPTION 'End time must be after start time';
    END IF;

   
    INSERT INTO student_exam (student_id, exam_id, start_time, end_time)
    VALUES (p_student_id, p_exam_id, p_start_time, p_end_time)
    RETURNING student_exam_id INTO v_student_exam_id;

    
    INSERT INTO student_answer (student_exam_id, question_id, chosen_choice_id)
    SELECT 
        v_student_exam_id,
        (elem->>'question_id')::INT,
        (elem->>'chosen_option_id')::INT
    FROM jsonb_array_elements(p_answers) AS elem;

END;
$$;