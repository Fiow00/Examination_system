CREATE MATERIALIZED VIEW "View_InstructorCourses" AS
SELECT 
    i."instructor_id",
    c."course_name" AS "CourseName", 
    t."track_name" AS "TrackName",
    (SELECT COUNT(*) FROM "student_track" st WHERE st."track_id" = t."track_id") AS "StudentCount"
FROM "instructor" i
JOIN "instructor_course" ic ON i."instructor_id" = ic."instructor_id"
JOIN "course" c ON ic."course_id" = c."course_id"
JOIN "track_course" tc ON c."course_id" = tc."course_id"
JOIN "track" t ON tc."track_id" = t."track_id";

