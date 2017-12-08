
BEGIN TRANSACTION;

/*
*** UPDATE STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid
*/

UPDATE mdj.mdj_stlloaderrors_with_null_userid
   SET tbl = ##BATCH_ID##
 WHERE userid = 4
;


/*
*** INSERT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid
*/

INSERT into mdj.mdj_stlloaderrors_with_null_userid
VALUES
(4,5,6)
, (7,8,9)
, (10, 11, 12)
--, (NULL, 14,15)
, (13, 14,15)
, (16, 17, 18)
;

/*
*** UPDATE STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid
*/

UPDATE mdj.mdj_stlloaderrors_with_null_userid
   SET tbl = ##BATCH_ID##
 WHERE userid = 4
;

END;

