
-- Insert Choice

CREATE OR REPLACE PROCEDURE add_choice(
    question_id_input INT,
    choice_body_input TEXT,
    choice_order_input INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    question_type TEXT;
    choice_count INT;
BEGIN

    IF choice_body_input IS NULL OR TRIM(choice_body_input) = '' THEN
        RAISE EXCEPTION 'Choice body cannot be empty';
    END IF;

    IF choice_order_input IS NULL OR choice_order_input <= 0 THEN
        RAISE EXCEPTION 'Choice order must be positive';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM question 
        WHERE question_id = question_id_input
    ) THEN
        RAISE EXCEPTION 'Question not found';
    END IF;

    SELECT type INTO question_type 
    FROM question 
    WHERE question_id = question_id_input;

    IF question_type = 'MCQ' AND (choice_order_input < 1 OR choice_order_input > 4) THEN
        RAISE EXCEPTION 'MCQ choices must be between 1 and 4';
    ELSIF question_type = 'TF' AND (choice_order_input < 1 OR choice_order_input > 2) THEN
        RAISE EXCEPTION 'TF choices must be between 1 and 2';
    END IF;

    SELECT COUNT(*) INTO choice_count 
    FROM choice 
    WHERE question_id = question_id_input;

    IF question_type = 'MCQ' AND choice_count >= 4 THEN
        RAISE EXCEPTION 'MCQ question cannot have more than 4 choices';
    ELSIF question_type = 'TF' AND choice_count >= 2 THEN
        RAISE EXCEPTION 'TF question cannot have more than 2 choices';
    END IF;

    IF EXISTS (
        SELECT 1 FROM choice 
        WHERE question_id = question_id_input 
        AND choice_order = choice_order_input
    ) THEN
        RAISE EXCEPTION 'Choice order already exists for this question';
    END IF;

    INSERT INTO choice (question_id, choice_body, choice_order)
    VALUES (question_id_input, choice_body_input, choice_order_input);
END;
$$;


-- ====================================================================================
-- Update Choice

CREATE OR REPLACE PROCEDURE update_choice(
    choice_id_input INT,
    choice_body_input TEXT,
    choice_order_input INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    question_id_value INT;
    question_type TEXT;
BEGIN

    IF choice_body_input IS NULL OR TRIM(choice_body_input) = '' THEN
        RAISE EXCEPTION 'Choice body cannot be empty';
    END IF;

    IF choice_order_input IS NULL OR choice_order_input <= 0 THEN
        RAISE EXCEPTION 'Choice order must be positive';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM choice 
        WHERE choice_id = choice_id_input
    ) THEN
        RAISE EXCEPTION 'Choice not found';
    END IF;

    SELECT question_id INTO question_id_value 
    FROM choice 
    WHERE choice_id = choice_id_input;

    SELECT type INTO question_type 
    FROM question 
    WHERE question_id = question_id_value;

    IF question_type = 'MCQ' AND (choice_order_input < 1 OR choice_order_input > 4) THEN
        RAISE EXCEPTION 'MCQ choices must be between 1 and 4';
    ELSIF question_type = 'TF' AND (choice_order_input < 1 OR choice_order_input > 2) THEN
        RAISE EXCEPTION 'TF choices must be between 1 and 2';
    END IF;

    IF EXISTS (
        SELECT 1 FROM choice 
        WHERE question_id = question_id_value 
        AND choice_order = choice_order_input 
        AND choice_id <> choice_id_input
    ) THEN
        RAISE EXCEPTION 'Choice order already exists for this question';
    END IF;

    UPDATE choice
    SET choice_body = choice_body_input,
        choice_order = choice_order_input
    WHERE choice_id = choice_id_input;
END;
$$;


-- ========================================================================================
-- Delete Choice

CREATE OR REPLACE PROCEDURE delete_choice(
    choice_id_input INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    question_id_value INT;
    question_type TEXT;
    choice_count INT;
BEGIN

    IF NOT EXISTS (
        SELECT 1 FROM choice 
        WHERE choice_id = choice_id_input
    ) THEN
        RAISE EXCEPTION 'Choice not found';
    END IF;

    SELECT question_id INTO question_id_value 
    FROM choice 
    WHERE choice_id = choice_id_input;

    SELECT type INTO question_type 
    FROM question 
    WHERE question_id = question_id_value;

    SELECT COUNT(*) INTO choice_count 
    FROM choice 
    WHERE question_id = question_id_value;

    IF question_type = 'MCQ' AND (choice_count - 1 < 4) THEN
        RAISE EXCEPTION 'MCQ must have at least 4 choices';
    ELSIF question_type = 'TF' AND (choice_count - 1 < 2) THEN
        RAISE EXCEPTION 'TF must have exactly 2 choices';
    END IF;

    DELETE FROM choice
    WHERE choice_id = choice_id_input;
END;
$$;
