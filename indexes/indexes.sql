CREATE INDEX "track_department_index" ON "track"("department_id");

CREATE INDEX "track_course_index" ON "track_course"("track_id", "course_id");

CREATE INDEX "instructor_index" ON "instructor"("department_id");

CREATE INDEX "student_track_index" ON "student_track"("track_id");

CREATE INDEX "question_index" ON "question"("course_id");

CREATE INDEX "choice_index" ON "choice"("question_id");

CREATE INDEX "exam_index" ON "exam"("course_id");

CREATE INDEX "student_exam_index" ON "student_exam"("student_id", "exam_id");

CREATE INDEX "student_answer_index" ON "student_answer"("student_exam_id");

CREATE UNIQUE INDEX "unique_course_name_index" ON "course"(LOWER("course_name"));
