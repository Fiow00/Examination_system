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
