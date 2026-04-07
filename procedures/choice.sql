
-- Insert Choice

CREATE OR REPLACE PROCEDURE add_choice(q_id INT, c_body TEXT, c_order INT)
LANGUAGE plpgsql
AS $$
DECLARE
    q_type TEXT;
    choice_count INT;
BEGIN


    IF c_body IS NULL OR TRIM(c_body) = '' THEN
        RAISE EXCEPTION 'Choice body cannot be empty';
    END IF;


    IF c_order IS NULL OR c_order <= 0 THEN
        RAISE EXCEPTION 'Choice order must be positive';
    END IF;


    IF NOT EXISTS (SELECT 1 FROM question WHERE question_id = q_id) THEN
        RAISE EXCEPTION 'Question not found';
    END IF;


    SELECT type INTO q_type FROM question WHERE question_id = q_id;


    IF q_type = 'MCQ' AND (c_order < 1 OR c_order > 4) THEN
        RAISE EXCEPTION 'MCQ choices must be between 1 and 4';
    ELSIF q_type = 'TF' AND (c_order < 1 OR c_order > 2) THEN
        RAISE EXCEPTION 'TF choices must be between 1 and 2';
    END IF;


    SELECT COUNT(*) INTO choice_count FROM choice WHERE question_id = q_id;

    IF q_type = 'MCQ' AND choice_count >= 4 THEN
        RAISE EXCEPTION 'MCQ question cannot have more than 4 choices';
    ELSIF q_type = 'TF' AND choice_count >= 2 THEN
        RAISE EXCEPTION 'TF question cannot have more than 2 choices';
    END IF;


    IF EXISTS (
        SELECT 1 FROM choice 
        WHERE question_id = q_id AND choice_order = c_order
    ) THEN
        RAISE EXCEPTION 'Choice order already exists for this question';
    END IF;

    INSERT INTO choice (question_id, choice_body, choice_order)
    VALUES (q_id, c_body, c_order);
END;
$$;


-- ====================================================================================
-- Update Choice

CREATE OR REPLACE PROCEDURE update_choice(c_id INT, c_body TEXT, c_order INT)
LANGUAGE plpgsql
AS $$
DECLARE
    q_id INT;
    q_type TEXT;
BEGIN


    IF c_body IS NULL OR TRIM(c_body) = '' THEN
        RAISE EXCEPTION 'Choice body cannot be empty';
    END IF;


    IF c_order IS NULL OR c_order <= 0 THEN
        RAISE EXCEPTION 'Choice order must be positive';
    END IF;


    IF NOT EXISTS (SELECT 1 FROM choice WHERE choice_id = c_id) THEN
        RAISE EXCEPTION 'Choice not found';
    END IF;


    SELECT question_id INTO q_id FROM choice WHERE choice_id = c_id;
    SELECT type INTO q_type FROM question WHERE question_id = q_id;


    IF q_type = 'MCQ' AND (c_order < 1 OR c_order > 4) THEN
        RAISE EXCEPTION 'MCQ choices must be between 1 and 4';
    ELSIF q_type = 'TF' AND (c_order < 1 OR c_order > 2) THEN
        RAISE EXCEPTION 'TF choices must be between 1 and 2';
    END IF;


    IF EXISTS (
        SELECT 1 FROM choice 
        WHERE question_id = q_id 
        AND choice_order = c_order 
        AND choice_id <> c_id
    ) THEN
        RAISE EXCEPTION 'Choice order already exists for this question';
    END IF;

    UPDATE choice
    SET choice_body = c_body,
        choice_order = c_order
    WHERE choice_id = c_id;
END;
$$;


-- ==================================================================================
-- Delete Choice

CREATE OR REPLACE PROCEDURE delete_choice(c_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    q_id INT;
    q_type TEXT;
    choice_count INT;
BEGIN


    IF NOT EXISTS (SELECT 1 FROM choice WHERE choice_id = c_id) THEN
        RAISE EXCEPTION 'Choice not found';
    END IF;


    SELECT question_id INTO q_id FROM choice WHERE choice_id = c_id;
    SELECT type INTO q_type FROM question WHERE question_id = q_id;


    SELECT COUNT(*) INTO choice_count FROM choice WHERE question_id = q_id;


    IF q_type = 'MCQ' AND (choice_count - 1 < 4) THEN
        RAISE EXCEPTION 'MCQ must have at least 4 choices';
    ELSIF q_type = 'TF' AND (choice_count - 1 < 2) THEN
        RAISE EXCEPTION 'TF must have exactly 2 choices';
    END IF;

    DELETE FROM choice
    WHERE choice_id = c_id;
END;
$$;
