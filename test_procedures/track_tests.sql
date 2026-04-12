CALL add_track('Docker', 1);                        -- Inserted


CALL add_track('', 1);                                  -- Exception: Empty track name


CALL add_track('Docker', 1);                           --Exception: Dublicate


CALL update_track(1, 'Updated Track', 1);                 --Updated


CALL update_track(999, 'X', 1);                         --Wrong id


CALL delete_track(1);                               --Deleted
