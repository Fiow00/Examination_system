CALL add_instructor('Test Instructor', 'test@iti.com', 1);   --Inserted

CALL add_instructor('', 'test2@iti.com', 1);                --Exception: empty name

CALL add_instructor('Test2', 'test@iti.com', 1);            -- Exteption: Dublicate Name


