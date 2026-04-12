CALL add_instructor('Test Instructor', 'test@iti.com', 1);   --Inserted

CALL add_instructor('', 'test2@iti.com', 1);                --Exception: empty name

CALL add_instructor('Test2', 'test@iti.com', 1);            -- Exteption: Dublicate Name


CALL update_instructor(1, 'Updated Name', 'updated@iti.com', 1);           --Updated

CALL update_instructor(999, 'Test', 't@t.com', 1);                     --Wrong id

CALL delete_instructor(1);                                      --Deleted


