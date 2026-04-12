-- =========================
-- Submit Exam Tests
-- =========================

   
CALL SubmitExamAnswers(
    1,
    1,
    NOW(),
    NOW() + INTERVAL '30 minutes',
    '[
        {"question_id":1, "chosen_option_id":1},
        {"question_id":2, "chosen_option_id":3}
    ]'::jsonb
);

  
CALL SubmitExamAnswers(
    1,
    1,
    NOW(),
    NOW() - INTERVAL '30 minutes',
    '[]'::jsonb
);

  
CALL SubmitExamAnswers(
    1,
    1,
    NOW(),
    NOW() + INTERVAL '30 minutes',
    '[
        {"question_id":1, "chosen_option_id":41}
    ]'::jsonb
);

  
CALL SubmitExamAnswers(
    1,
    999,
    NOW(),
    NOW() + INTERVAL '30 minutes',
    '[]'::jsonb
);