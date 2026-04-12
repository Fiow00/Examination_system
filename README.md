# ITI Examination Management System

## Overview

This project implements a database-driven Examination Management System using PostgreSQL.
It is designed to manage exams, question banks, student answers, grading, and reporting.

All business logic is implemented using PL/pgSQL stored procedures, with strong emphasis on data integrity, performance, and security.

---

## Features

* Complete relational database schema with constraints and relationships
* Question bank supporting MCQ and True/False questions
* Randomized exam generation without duplicates
* Exam submission and answer storage
* Automatic exam correction
* Role-based access control
* Optimized queries using indexes
* Backup and restore support
* Reporting system

---

## Database Entities

* Department
* Track
* Course
* Instructor
* Student
* Question
* Choice
* Model Answer
* Exam
* Exam Question
* Student Exam
* Student Answer

---

## Technologies Used

* PostgreSQL
* PL/pgSQL
* Git and GitHub

---

## Core Procedures

* generate_exam: Generates randomized exams based on available questions
* submit_exam: Stores student answers
* correct_exam: Calculates and updates student grades

---

## Security

Role-based access control is implemented using PostgreSQL roles:

* Admin: Full access to all database objects
* Instructor: Manage exams, questions, and grading
* Student: Access exams and submit answers only

Sensitive data such as model answers is restricted from students.

---

## Reports

* Students by Department
* Student Grades
* Instructor Courses

---

## Performance

* Indexes are created on foreign keys and frequently queried columns
* Queries are optimized to meet performance requirements
* Exam generation supports up to 50 questions efficiently

---

## Backup and Restore

### Backup

```bash
pg_dump -U postgres -d iti_exam_db -F c -f iti_exam_backup.dump
```

### Restore

```bash
pg_restore -U postgres -d iti_exam_db -c iti_exam_backup.dump
```

---

## Project Structure

```
schema/
procedures/
  core/
  crud/
  question_bank/
reports/
sample_data/
test_procedures/
triggers/
setup/
```

---

## Team Contributions

### Ahmed

* ERD design
* Database schema
* Indexes and performance optimization
* Triggers
* Sample data
* Procedures:

  * course
  * generate_exam
* Security (roles and privileges)
* Backup and restore

### Mohamed El-Fityani

* Procedures:

  * track
  * instructor
  * choice
  * correct_exam

### Mohamed Nasef

* Procedures:

  * department
  * model_answer
  * submit_exam

### Mawada Ahmed

* Procedures:

  * student
  * question
* Reports implementation

---

## Design Decisions

* Data integrity enforced using constraints and triggers
* Only questions with valid model answers are included in exams
* Random selection ensures no duplicate questions
* Role-based security prevents unauthorized access
* Business logic implemented at the database level

---

## Notes

* This is a backend-focused project
* Designed to be scalable and maintainable
* Supports both Arabic and English text

---

## Conclusion

This project demonstrates practical experience in:

* Database design and normalization
* Advanced SQL and PL/pgSQL
* Query optimization
* Secure database systems
