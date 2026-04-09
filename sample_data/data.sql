-- Department --
INSERT INTO "department" ("department_name", "location") 
VALUES
('Open Source', 'Cairo'),
('Artificial Intelligence', 'Alexandria'),
('Web Development', 'Giza');

-- Track --
INSERT INTO "track" ("track_name", "department_id") 
VALUES
('Python Track', 1),
('Django Track', 1),
('Machine Learning Track', 2),
('Data Science Track', 2),
('Frontend Track', 3),
('Backend Track', 3);

-- Course --
INSERT INTO "course" ("course_name", "min_degree", "max_degree") 
VALUES
('python basics', 0, 100),
('django fundamentals', 0, 100),
('machine learning intro', 0, 100),
('statistics basics', 0, 100),
('html css', 0, 100);

-- Track_Course --
INSERT INTO "track_course" ("track_id", "course_id") 
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,2),
(1,2);

-- Instrucotr --
INSERT INTO "instructor" ("name", "email", "department_id") 
VALUES
('Ahmed Ali', 'ahmed@iti.com', 1),
('Sara Mohamed', 'sara@iti.com', 2),
('Omar Khaled', 'omar@iti.com', 3);

-- instructor_course --
INSERT INTO "instructor_course" ("instructor_id", "course_id") 
VALUES
(1,1),
(1,2),
(2,3),
(2,4),
(3,5);

-- Student --
INSERT INTO "student" ("name", "email", "phone") 
VALUES
('Ali Hassan', 'ali@mail.com', '0100000000'),
('Mona Adel', 'mona@mail.com', '0100000001'),
('Youssef Samy', 'youssef@mail.com', '0100000002'),
('Nour Ahmed', 'nour@mail.com', '0100000003'),
('Hassan Mostafa', 'hassan@mail.com', '0100000004');

-- Student_Track --
INSERT INTO "student_track" ("student_id", "track_id") 
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

-- Question --
INSERT INTO "question" ("course_id", "question_body", "type", "points") 
VALUES
(1, 'Python is an interpreted language?', 'TF', 5),
(1, 'Which of the following is a Python list?', 'MCQ', 5),
(2, 'Django is a web framework?', 'TF', 5),
(2, 'Which is a valid Django model field?', 'MCQ', 5),
(3, 'Machine learning requires data?', 'TF', 5);

-- Choice --
INSERT INTO "choice" ("question_id", "choice_body", "choice_order") VALUES
-- Q1
(1, 'True', 1),
(1, 'False', 2),

-- Q2
(2, 'List using []', 1),
(2, 'Dictionary using {}', 2),
(2, 'Tuple using ()', 3),
(2, 'Invalid syntax', 4),

-- Q3
(3, 'True', 1),
(3, 'False', 2),

-- Q4
(4, 'CharField', 1),
(4, 'IntegerField', 2),
(4, 'InvalidField', 3),
(4, 'None', 4),

-- Q5
(5, 'True', 1),
(5, 'False', 2);

-- ModelAnswer -- 
INSERT INTO "model_answer" ("question_id", "correct_choice_id") 
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1);

