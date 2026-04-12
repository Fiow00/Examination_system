
CALL add_choice(1, 'Choice 1', 1);
CALL add_choice(1, 'Choice 2', 2);
CALL add_choice(1, 'Choice 3', 3);
CALL add_choice(1, 'Choice 4', 4);                --Inserted 4 Choices


CALL add_choice(1, 'Extra Choice', 5);            -- Added choice Exception

CALL add_choice(1, '', 1);                     -- Empty Exception

CALL add_choice(1, 'Duplicate Order', 1);            --Dublicate exception

CALL update_choice(1, 'Updated Choice', 2);         --Update choice


CALL update_choice(999, 'X', 1);                    --id error


CALL delete_choice(1);                     --Exception must be 4 
