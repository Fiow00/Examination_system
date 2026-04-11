-- TEST: Student & Track 


-- 1. Success Tests: Adding Students
CALL "insert_student"('Mawada Student', 'mawada@iti.edu.eg', '01012345678');
CALL "insert_student"('Ahmed Tech', 'ahmed@iti.edu.eg', '01122334455');

-- 2. Failure Test: Duplicate Email (Should trigger ON CONFLICT notice)
CALL "insert_student"('Duplicate User', 'mawada@iti.edu.eg', '01500000000');

-- 3. Success Test: Update Student
CALL "update_student"(1, 'Mawada ITI', 'mawada.new@iti.edu.eg', '01299999999');

-- 4. Failure Test: Update to an existing email (Conflict check)
CALL "update_student"(2, 'Ahmed New', 'mawada.new@iti.edu.eg', '01100000000');

-- 5. Success Test: Assign Student to Track
-- (Assumes Track ID 1 and 2 exist from the course tests)
CALL "assign_student_to_track"(1, 1);
CALL "assign_student_to_track"(1, 2);

-- 6. Failure Test: Assign to non-existent Track (Triggers foreign_key_violation)
CALL "assign_student_to_track"(1, 999);

-- 7. Success Test: Delete Student
-- (This will also cascade delete their track assignments)
CALL "delete_student"(2);

-- 8. Failure Test: Delete non-existent Student
CALL "delete_student"(999);