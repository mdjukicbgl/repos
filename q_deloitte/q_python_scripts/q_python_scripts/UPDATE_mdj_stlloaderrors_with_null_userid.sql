--do $$
--begin

BEGIN TRANSACTION;

update mdj.mdj_stlloaderrors_with_null_userid
   set tbl = ##BATCH_ID##
 where userid = 1
;

insert into  mdj.mdj_stlloaderrors_with_null_userid
values (NULL,4,5)
;

commit;

END;

/*
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;

    raise notice 'called from within the Transaction was rolled back';

    raise notice '% %', SQLERRM, SQLSTATE;
END;
$$ language 'plpgsql';
*/

