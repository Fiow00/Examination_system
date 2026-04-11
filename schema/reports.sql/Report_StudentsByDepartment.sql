CREATE OR REPLACE VIEW "View_StudentsByDepartment" AS
SELECT 
    d."department_id", -- Keep the ID for filtering later
    s."student_id" AS "StudentID", 
    s."name" AS "Name", 
    s."email" AS "Email", 
    s."phone" AS "Phone", 
    t."track_name" AS "TrackName"
FROM "student" s
JOIN "student_track" st ON s."student_id" = st."student_id"
JOIN "track" t ON st."track_id" = t."track_id"
JOIN "department" d ON t."department_id" = d."department_id";

