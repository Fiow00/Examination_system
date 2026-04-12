-- Department --
CREATE TABLE "department" (
    "department_id" SERIAL,
    "department_name" TEXT NOT NULL,
    "location" TEXT,
    PRIMARY KEY ("department_id"),
    UNIQUE ("department_name", "location")
);

-- Track --
CREATE TABLE "track" (
    "track_id" SERIAL,
    "track_name" TEXT NOT NULL,
    "department_id" INT NOT NULL,
    UNIQUE ("track_name", "department_id"),
    PRIMARY KEY ("track_id"),
    FOREIGN KEY ("department_id") REFERENCES "department"("department_id") ON DELETE CASCADE
);

-- Course --
CREATE TABLE "course" (
    "course_id" SERIAL,
    "course_name" TEXT NOT NULL UNIQUE CHECK(
        LENGTH(TRIM("course_name")) >= 2
        AND LENGTH("course_name") <= 100
    ),
    "min_degree" INT NOT NULL CHECK ("min_degree" >= 0),
    "max_degree" INT NOT NULL CHECK ("max_degree" > "min_degree" AND "max_degree" <= 100),
    PRIMARY KEY ("course_id")
);

-- Track_Course --
CREATE TABLE "track_course" (
    "track_id" INT,
    "course_id" INT,
    PRIMARY KEY ("track_id", "course_id"),
    FOREIGN KEY ("track_id") REFERENCES "track"("track_id") ON DELETE CASCADE,
    FOREIGN KEY ("course_id") REFERENCES "course"("course_id") ON DELETE CASCADE
);

-- Instructor --
CREATE TABLE "instructor" (
    "instructor_id" SERIAL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "department_id" INT,
    PRIMARY KEY ("instructor_id"),
    FOREIGN KEY ("department_id") REFERENCES "department"("department_id") ON DELETE SET NULL
);

-- Instructor_Course --
CREATE TABLE "instructor_course" (
    "instructor_id" INT,
    "course_id" INT,
    PRIMARY KEY ("instructor_id", "course_id"),
    FOREIGN KEY ("instructor_id") REFERENCES "instructor"("instructor_id") ON DELETE CASCADE,
    FOREIGN KEY ("course_id") REFERENCES "course"("course_id") ON DELETE CASCADE
);

-- Student --
CREATE TABLE "student" (
    "student_id" SERIAL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "phone" TEXT,
    PRIMARY KEY ("student_id")
);

-- Student_Track --
CREATE TABLE "student_track" (
    "student_id" INT,
    "track_id" INT,
    PRIMARY KEY ("student_id", "track_id"),
    FOREIGN KEY ("student_id") REFERENCES "student"("student_id") ON DELETE CASCADE,
    FOREIGN KEY ("track_id") REFERENCES "track"("track_id") ON DELETE CASCADE
);

-- Question --
CREATE TABLE "question" (
    "question_id" SERIAL,
    "course_id" INT NOT NULL,
    "question_body" TEXT NOT NULL CHECK (TRIM("question_body") <> ''),
    "type" TEXT NOT NULL CHECK ("type" IN ('MCQ', 'TF')),
    "points" INT NOT NULL CHECK ("points" > 0),
    PRIMARY KEY ("question_id"),
    FOREIGN KEY ("course_id") REFERENCES "course"("course_id") ON DELETE CASCADE
);

-- Choice --
CREATE TABLE "choice" (
    "choice_id" SERIAL,
    "question_id" INT NOT NULL,
    "choice_body" TEXT NOT NULL,
    "choice_order" INT NOT NULL CHECK ("choice_order" > 0),
    PRIMARY KEY ("choice_id"),
    FOREIGN KEY ("question_id") REFERENCES "question"("question_id") ON DELETE CASCADE,
    UNIQUE ("question_id", "choice_order")
);

-- ModelAnswer --
CREATE TABLE "model_answer" (
    "question_id" INT,
    "correct_choice_id" INT,
    PRIMARY KEY ("question_id"),
    FOREIGN KEY ("question_id") REFERENCES "question"("question_id") ON DELETE CASCADE,
    FOREIGN KEY ("correct_choice_id") REFERENCES "choice"("choice_id") ON DELETE RESTRICT
);

-- Exam --
CREATE TABLE "exam" (
    "exam_id" SERIAL,
    "name" TEXT NOT NULL,
    "course_id" INT NOT NULL,
    "total_questions" INT NOT NULL CHECK ("total_questions" BETWEEN 1 AND 100),
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("exam_id"),
    FOREIGN KEY ("course_id") REFERENCES "course"("course_id") ON DELETE CASCADE,
    UNIQUE ("name", "course_id")
);

-- Exam_Question --
CREATE TABLE "exam_question" (
    "exam_id" INT,
    "question_id" INT,
    "order_number" INT NOT NULL CHECK ("order_number" > 0),
    PRIMARY KEY ("exam_id", "question_id"),
    FOREIGN KEY ("exam_id") REFERENCES "exam"("exam_id") ON DELETE CASCADE,
    FOREIGN KEY ("question_id") REFERENCES "question"("question_id") ON DELETE CASCADE,
    UNIQUE ("exam_id", "order_number")
);

-- Student_Exam --
CREATE TABLE "student_exam" (
    "student_exam_id" SERIAL,
    "student_id" INT NOT NULL,
    "exam_id" INT NOT NULL,
    "start_time" TIMESTAMP,
    "end_time" TIMESTAMP,
    "total_grade" INT DEFAULT 0,
    CHECK (
        "end_time" IS NULL 
        OR "end_time" >= "start_time"
    )
    PRIMARY KEY ("student_exam_id"),
    FOREIGN KEY ("student_id") REFERENCES "student"("student_id") ON DELETE CASCADE,
    FOREIGN KEY ("exam_id") REFERENCES "exam"("exam_id") ON DELETE CASCADE
);

-- Student_Answer --
CREATE TABLE "student_answer" (
    "student_answer_id" SERIAL,
    "student_exam_id" INT NOT NULL,
    "question_id" INT NOT NULL,
    "chosen_choice_id" INT,
    PRIMARY KEY ("student_answer_id"),
    FOREIGN KEY ("student_exam_id") REFERENCES "student_exam"("student_exam_id") ON DELETE CASCADE,
    FOREIGN KEY ("question_id") REFERENCES "question"("question_id") ON DELETE CASCADE,
    FOREIGN KEY ("chosen_choice_id") REFERENCES "choice"("choice_id") ON DELETE SET NULL,
    UNIQUE ("student_exam_id", "question_id")
);
