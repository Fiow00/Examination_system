/**
 * Database Indexes for Examination Management System
 * 
 * Purpose: Optimize query performance for critical lookups, foreign key relationships,
 *          and unique constraints across the examination database.
 * 
 * Index Strategy:
 * - Foreign key columns: Indexed for JOIN performance
 * - UNIQUE constraints: Explicit indexes for documentation and performance
 * - Composite keys: Indexed to support multi-column queries
 * - Reverse lookups: Added for bidirectional relationship queries
 * 
 * All UNIQUE indexes support Arabic and English text (ar_AR.utf8 collation where applicable)
 */

-- Track-Department relationship
CREATE INDEX "track_department_index" ON "track"("department_id");

-- Track-Course junction table
CREATE INDEX "track_course_index" ON "track_course"("track_id", "course_id");

-- Instructor relationship
CREATE INDEX "instructor_index" ON "instructor"("department_id");

-- Instructor_Course junction table indexes
CREATE INDEX "instructor_course_instructor_index" ON "instructor_course"("instructor_id");
CREATE INDEX "instructor_course_course_index" ON "instructor_course"("course_id");

-- Student_Track junction table indexes
CREATE INDEX "student_track_index" ON "student_track"("track_id");

-- Student_Track student lookup index
CREATE INDEX "student_track_student_index" ON "student_track"("student_id");

-- Question-Course relationship
CREATE INDEX "question_index" ON "question"("course_id");

-- Choice-Question relationship
CREATE INDEX "choice_index" ON "choice"("question_id");

-- Exam-Course relationship
CREATE INDEX "exam_index" ON "exam"("course_id");

-- Student_Exam relationship (critical for exam submission and grading)
CREATE INDEX "student_exam_index" ON "student_exam"("student_id", "exam_id");

-- Exam_Question junction table
CREATE INDEX "exam_question_index" ON "exam_question"("exam_id", "question_id");

-- Student_Answer relationship (critical for exam correction and reporting)
CREATE UNIQUE INDEX "student_answer_index" ON "student_answer"("student_exam_id", "question_id");

-- Model_Answer indexes
CREATE UNIQUE INDEX "model_answer_question_index" ON "model_answer"("question_id");

-- ModelAnswer reverse lookup index for choice relationships
CREATE INDEX "model_answer_choice_index" ON "model_answer"("correct_choice_id");

-- UNIQUE indexes for critical fields (schema constraints + explicit indexes for documentation)
CREATE UNIQUE INDEX "course_name_index" ON "course"(LOWER("course_name"));
CREATE UNIQUE INDEX "instructor_email_index" ON "instructor"("email");
CREATE UNIQUE INDEX "student_email_index" ON "student"("email");
CREATE UNIQUE INDEX "department_name_index" ON "department"("department_name");

