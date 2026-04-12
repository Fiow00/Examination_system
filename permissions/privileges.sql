DROP ROLE IF EXISTS admin;
DROP ROLE IF EXISTS instructor;
DROP ROLE IF EXISTS student;

CREATE ROLE admin LOGIN PASSWORD 'crimson';
CREATE ROLE instructor LOGIN PASSWORD 'crimson';
CREATE ROLE student LOGIN PASSWORD 'crimson';


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA "public" TO "admin";
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA "public" TO "admin";
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA "public" TO "admin";
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA "public" TO "admin";


GRANT SELECT, INSERT, UPDATE ON 
    "course", "question", "choice", "model_answer", "exam", "exam_question"
TO "instructor";

GRANT EXECUTE ON PROCEDURE "generate_exam" TO "instructor";
GRANT EXECUTE ON PROCEDURE "correct_exam" TO "instructor";


GRANT SELECT ON 
    "exam", "exam_question", "question", "choice"
TO "student";

GRANT SELECT ON "student_exam", "student_answer" TO "student";

GRANT EXECUTE ON PROCEDURE "submit_exam" TO "student";

REVOKE ALL ON "model_answer" FROM "student";