CREATE OR REPLACE VIEW "View_StudentGrades" AS
SELECT 
    se."student_id" AS "StudentID",
    c."course_name" AS "CourseName", 
    e."name" AS "ExamName", 
    se."total_grade" AS "TotalGrade", 
    c."max_degree" AS "MaxDegree",
    ROUND((se."total_grade"::FLOAT / NULLIF(c."max_degree", 0) * 100)::NUMERIC, 2) AS "Percentage"
FROM "student_exam" se
JOIN "exam" e ON se."exam_id" = e."exam_id"
JOIN "course" c ON e."course_id" = c."course_id";

