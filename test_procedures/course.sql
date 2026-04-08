-- Test add_course procedure

-- Success Tests
CALL "add_course"('Database Design', 40, 100);
CALL "add_course"('Programming 101', 30, 95);

-- Failed Tests
CALL "add_course"('', 50, 90); -- Empyt name
CALL "add_course"('SQL@#$', 50, 90); -- Invalid characters
CALL "add_course"('12345', 50, 90); -- No letters
CALL "add_course"('Math', -10, 90); -- Negative min
CALL "add_course"('Physics', 80, 70);  -- Max < Min
CALL "add_course"('Chemistry', 50, 150); -- Max > 100
CALL "add_course"('Database Design', 40, 100); -- Exist before


-- Test update_course procedure

-- Success Tests
CALL "update_course"(1, 'Advanced Database', 50, 100);
CALL "update_course"(2, 'Programming Basics', 35, 90);

-- Failed Tests
CALL "update_course"(999, 'Test', 50, 90); -- Not exists
CALL "update_course"(1, '', 50, 90); -- Empty
CALL "update_course"(1, '###', 50, 90); -- Invalid characters
CALL "update_course"(1, 'Math', -10, 90); -- Negative min
CALL "update_course"(1, 'Physics', 80, 70); -- Max < Min
CALL "update_course"(1, 'Chemistry', 50, 150); -- Max > 100
CALL "update_course"(1, 'Progamming 101', 30, 95); -- Duplicate name


-- Test delete_course procedure

-- Success Tests
CALL "delete_course"(3); -- If not linked to anything

-- Fail Tests
CALL "delete_course"(999); -- Not Exists

-- These depend on you data (prepare them first)
CALL "delete_course"(1);
CALL "delete_course"(2);
CALL "delete_course"(1);


-- Test get_course_by_track

-- Success Tests
SELECT * FROM "get_course_by_track"(1);
SELECT * FROM "get_course_by_track"(2);

-- Fail Tests
SELECT * FROM "get_course_by_track"(999);

