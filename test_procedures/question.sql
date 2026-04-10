-- TEST: Question & Choice 


-- 1. Success Test: Insert Questions
CALL "InsertQuestion"(1, 'What does SQL stand for?', 'MCQ', 5);
CALL "InsertQuestion"(1, 'PostgreSQL is a NoSQL database.', 'TF', 2);

-- 2. Failure Test: Invalid Type (Triggers check_violation)
CALL "InsertQuestion"(1, 'Wrong Type Question', 'ShortAnswer', 5);

-- 3. Failure Test: Negative Points (Triggers check_violation)
CALL "InsertQuestion"(1, 'Negative Points Test', 'MCQ', -10);

-- 4. Success Test: Update Question
CALL "UpdateQuestion"(1, 'Explain the full form of SQL', 10);

-- 5. Failure Test: Delete Question 
-- This will fail cause there is data in "exam_question" for this ID)
CALL "delete_question"(1);