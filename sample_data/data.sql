-- Department --
INSERT INTO "department" ("department_name", "location") 
VALUES
('Open Source', 'Cairo'),
('AI', 'Alex'),
('Web', 'Giza');

-- Track --
INSERT INTO "track" ("track_name", "department_id") 
VALUES
('Python', 1),
('Django', 1),
('Machine Learning', 2),
('Data Science', 2),
('Frontend', 3),
('Backend', 3);

-- Course --
INSERT INTO "course" ("course_name", "min_degree", "max_degree") 
VALUES
('Python Basics', 0, 100),
('Django', 0, 100),
('ML Intro', 0, 100),
('Statistics', 0, 100),
('HTML/CSS', 0, 100);

-- Track_Course --
INSERT INTO "track_course" ("track_id", "course_id") 
VALUES
(1,1), (2,2), (3,3), (4,4), (5,5),
(6,2), (1,2);

-- Instrucotr --
INSERT INTO "instructor" ("name", "email", "department_id") 
VALUES
('Ahmed Ali', 'ahmed@iti.com', 1),
('Sara Mohamed', 'sara@iti.com', 2),
('Omar Khaled', 'omar@iti.com', 3);

-- instructor_course --
INSERT INTO "instructor_course" ("instructor_id", "course_id") 
VALUES
(1,1), (1,2),
(2,3), (2,4),
(3,5);

-- Student --
INSERT INTO "student" ("name", "email", "phone") 
VALUES
('Ali', 'ali@mail.com', '0100'),
('Mona', 'mona@mail.com', '0101'),
('Youssef', 'youssef@mail.com', '0102'),
('Nour', 'nour@mail.com', '0103'),
('Hassan', 'hassan@mail.com', '0104');

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
(1, 'Python is interpreted?', 'TF', 5),
(1, 'Which is a list?', 'MCQ', 5),
(2, 'Django is a framework?', 'TF', 5),
(2, 'Which is a model field?', 'MCQ', 5),
(3, 'ML needs data?', 'TF', 5);

-- Choice --
INSERT INTO "choice" ("question_id", "choice_body", "choice_order") VALUES
-- Q1 (TF)
(1, 'True', 1),
(1, 'False', 2),

-- Q2 (MCQ)
(2, '[]', 1),
(2, '{}', 2),
(2, '()', 3),
(2, '<>', 4),

-- Q3 (TF)
(3, 'True', 1),
(3, 'False', 2),

-- Q4 (MCQ)
(4, 'CharField', 1),
(4, 'IntegerField', 2),
(4, 'FakeField', 3),
(4, 'None', 4),

-- Q5 (TF)
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

