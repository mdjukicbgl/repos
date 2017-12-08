
2017-07-24 12:26:28,186 - INFO -  +----------------------------------------------------------------------------------------------------+
2017-07-24 12:26:28,186 - INFO -  | Script: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/LoadTransform.py STARTING
2017-07-24 12:26:28,186 - INFO -  +----------------------------------------------------------------------------------------------------+
2017-07-24 12:26:28,186 - INFO -  | In function "main"
2017-07-24 12:26:28,186 - INFO -  | In function "isBatchIdValid"
2017-07-24 12:26:28,186 - INFO -  |	 Validating BATCH_ID passed from command line
2017-07-24 12:26:28,186 - INFO -  |	 BATCH_ID: 9876 passed is VALID
2017-07-24 12:26:28,186 - INFO -  | In function "create_conn"
2017-07-24 12:26:28,186 - INFO -  |	 Opening Redshift connection
2017-07-24 12:26:28,410 - INFO -  | Validating existence of transform file passed: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:28,410 - INFO -  | In function "isTransformFilePresent"
2017-07-24 12:26:28,410 - INFO -  |	 Transform file exists-->/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:28,410 - INFO -  | In function "readfile"
2017-07-24 12:26:28,411 - INFO -  |	 Transform file being retured to main() for population of "query_string" variable
2017-07-24 12:26:28,411 - INFO -  | Initializing query_string, from transform file
2017-07-24 12:26:28,411 - INFO -  | -----------------------------------
2017-07-24 12:26:28,411 - INFO -  | Transform below, called to execute:
2017-07-24 12:26:28,411 - INFO -  | -----------------------------------
2017-07-24 12:26:28,411 - INFO -  |
2017-07-24 12:26:28,411 - INFO -  |	 
2017-07-24 12:26:28,411 - INFO -  |	 SELECT 'PROGRESS COUNTER - SELECT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,411 - INFO -  |	 
2017-07-24 12:26:28,411 - INFO -  |	 SELECT *
2017-07-24 12:26:28,411 - INFO -  |	   FROM mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,411 - INFO -  |	 ;
2017-07-24 12:26:28,524 - INFO -  | In function "create_conn"
2017-07-24 12:26:28,525 - INFO -  |	 Opening Redshift connection
2017-07-24 12:26:28,840 - INFO -  | Validating existence of transform file passed: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/UPDATE_mdj_stlloaderrors_with_null_userid_multirecs.sql
2017-07-24 12:26:28,840 - INFO -  | In function "isTransformFilePresent"
2017-07-24 12:26:28,840 - INFO -  |	 Transform file exists-->/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/UPDATE_mdj_stlloaderrors_with_null_userid_multirecs.sql
2017-07-24 12:26:28,840 - INFO -  | In function "readfile"
2017-07-24 12:26:28,841 - INFO -  |	 Transform file being retured to main() for population of "query_string" variable
2017-07-24 12:26:28,841 - INFO -  | Initializing query_string, from transform file
2017-07-24 12:26:28,841 - INFO -  | -----------------------------------
2017-07-24 12:26:28,841 - INFO -  | Transform below, called to execute:
2017-07-24 12:26:28,841 - INFO -  | -----------------------------------
2017-07-24 12:26:28,841 - INFO -  |
2017-07-24 12:26:28,841 - INFO -  |	 
2017-07-24 12:26:28,841 - INFO -  |	 BEGIN TRANSACTION;
2017-07-24 12:26:28,841 - INFO -  |	 
2017-07-24 12:26:28,841 - INFO -  |	 SELECT 'PROGRESS COUNTER - UPDATE STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,841 - INFO -  |	 
2017-07-24 12:26:28,841 - INFO -  |	 update mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,841 - INFO -  |	    set tbl = ##BATCH_ID##
2017-07-24 12:26:28,842 - INFO -  |	  where userid = 4
2017-07-24 12:26:28,842 - INFO -  |	 ;
2017-07-24 12:26:28,842 - INFO -  |	 
2017-07-24 12:26:28,842 - INFO -  |	 SELECT 'PROGRESS COUNTER - INSERT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,842 - INFO -  |	 
2017-07-24 12:26:28,842 - INFO -  |	 insert into mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,842 - INFO -  |	 values
2017-07-24 12:26:28,842 - INFO -  |	 (4,5,6)
2017-07-24 12:26:28,842 - INFO -  |	 , (7,8,9)
2017-07-24 12:26:28,842 - INFO -  |	 , (10, 11, 12)
2017-07-24 12:26:28,842 - INFO -  |	 --, (NULL, 14,15)
2017-07-24 12:26:28,842 - INFO -  |	 , (13, 14,15)
2017-07-24 12:26:28,842 - INFO -  |	 , (16, 17, 18)
2017-07-24 12:26:28,842 - INFO -  |	 ;
2017-07-24 12:26:28,842 - INFO -  |	 
2017-07-24 12:26:28,842 - INFO -  |	 SELECT 'PROGRESS COUNTER - SELECT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,842 - INFO -  |	 
2017-07-24 12:26:28,842 - INFO -  |	 update mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,843 - INFO -  |	    set tbl = ##BATCH_ID##
2017-07-24 12:26:28,843 - INFO -  |	  where userid = 4
2017-07-24 12:26:28,843 - INFO -  |	 ;
2017-07-24 12:26:28,843 - INFO -  |	 
2017-07-24 12:26:28,843 - INFO -  |	 END;
2017-07-24 12:26:28,843 - INFO -  |	 
2017-07-24 12:26:28,843 - INFO -  | Initializing REPLACEMENT query_string, from transform file
2017-07-24 12:26:28,843 - INFO -  |
2017-07-24 12:26:28,843 - INFO -  | -----------------------------------------------
2017-07-24 12:26:28,843 - INFO -  | REPLACEMENT Transform below, called to execute:
2017-07-24 12:26:28,843 - INFO -  | -----------------------------------------------
2017-07-24 12:26:28,843 - INFO -  |
2017-07-24 12:26:28,843 - INFO -  |	 
2017-07-24 12:26:28,843 - INFO -  |	 BEGIN TRANSACTION;
2017-07-24 12:26:28,843 - INFO -  |	 
2017-07-24 12:26:28,843 - INFO -  |	 SELECT 'PROGRESS COUNTER - UPDATE STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,843 - INFO -  |	 
2017-07-24 12:26:28,844 - INFO -  |	 update mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,844 - INFO -  |	    set tbl = 9876
2017-07-24 12:26:28,844 - INFO -  |	  where userid = 4
2017-07-24 12:26:28,844 - INFO -  |	 ;
2017-07-24 12:26:28,844 - INFO -  |	 
2017-07-24 12:26:28,844 - INFO -  |	 SELECT 'PROGRESS COUNTER - INSERT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,844 - INFO -  |	 
2017-07-24 12:26:28,844 - INFO -  |	 insert into mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,844 - INFO -  |	 values
2017-07-24 12:26:28,844 - INFO -  |	 (4,5,6)
2017-07-24 12:26:28,844 - INFO -  |	 , (7,8,9)
2017-07-24 12:26:28,844 - INFO -  |	 , (10, 11, 12)
2017-07-24 12:26:28,844 - INFO -  |	 --, (NULL, 14,15)
2017-07-24 12:26:28,844 - INFO -  |	 , (13, 14,15)
2017-07-24 12:26:28,844 - INFO -  |	 , (16, 17, 18)
2017-07-24 12:26:28,844 - INFO -  |	 ;
2017-07-24 12:26:28,844 - INFO -  |	 
2017-07-24 12:26:28,845 - INFO -  |	 SELECT 'PROGRESS COUNTER - SELECT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:28,845 - INFO -  |	 
2017-07-24 12:26:28,845 - INFO -  |	 update mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:28,845 - INFO -  |	    set tbl = 9876
2017-07-24 12:26:28,845 - INFO -  |	  where userid = 4
2017-07-24 12:26:28,845 - INFO -  |	 ;
2017-07-24 12:26:28,845 - INFO -  |	 
2017-07-24 12:26:28,845 - INFO -  |	 END;
2017-07-24 12:26:28,845 - INFO -  |	 
2017-07-24 12:26:29,435 - INFO -  | In function "create_conn"
2017-07-24 12:26:29,435 - INFO -  |	 Opening Redshift connection
2017-07-24 12:26:29,668 - INFO -  | Validating existence of transform file passed: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/DELETE_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:29,668 - INFO -  | In function "isTransformFilePresent"
2017-07-24 12:26:29,668 - INFO -  |	 Transform file exists-->/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/DELETE_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:29,668 - INFO -  | In function "readfile"
2017-07-24 12:26:29,668 - INFO -  |	 Transform file being retured to main() for population of "query_string" variable
2017-07-24 12:26:29,669 - INFO -  | Initializing query_string, from transform file
2017-07-24 12:26:29,669 - INFO -  | -----------------------------------
2017-07-24 12:26:29,669 - INFO -  | Transform below, called to execute:
2017-07-24 12:26:29,669 - INFO -  | -----------------------------------
2017-07-24 12:26:29,669 - INFO -  |
2017-07-24 12:26:29,669 - INFO -  |	 BEGIN TRANSACTION;
2017-07-24 12:26:29,669 - INFO -  |	 
2017-07-24 12:26:29,669 - INFO -  |	 SELECT 'PROGRESS COUNTER - DELETE STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:29,669 - INFO -  |	 
2017-07-24 12:26:29,669 - INFO -  |	 delete from mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:29,669 - INFO -  |	  where userid = 13
2017-07-24 12:26:29,669 - INFO -  |	 ;
2017-07-24 12:26:30,199 - INFO -  | In function "create_conn"
2017-07-24 12:26:30,200 - INFO -  |	 Opening Redshift connection
2017-07-24 12:26:30,397 - INFO -  | Validating existence of transform file passed: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:30,397 - INFO -  | In function "isTransformFilePresent"
2017-07-24 12:26:30,397 - INFO -  |	 Transform file exists-->/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj_stlloaderrors_with_null_userid.sql
2017-07-24 12:26:30,397 - INFO -  | In function "readfile"
2017-07-24 12:26:30,398 - INFO -  |	 Transform file being retured to main() for population of "query_string" variable
2017-07-24 12:26:30,398 - INFO -  | Initializing query_string, from transform file
2017-07-24 12:26:30,398 - INFO -  | -----------------------------------
2017-07-24 12:26:30,398 - INFO -  | Transform below, called to execute:
2017-07-24 12:26:30,398 - INFO -  | -----------------------------------
2017-07-24 12:26:30,398 - INFO -  |
2017-07-24 12:26:30,398 - INFO -  |	 
2017-07-24 12:26:30,398 - INFO -  |	 SELECT 'PROGRESS COUNTER - SELECT STATEMENT RUNNING ON TABLE mdj.mdj_stlloaderrors_with_null_userid';
2017-07-24 12:26:30,398 - INFO -  |	 
2017-07-24 12:26:30,398 - INFO -  |	 SELECT *
2017-07-24 12:26:30,398 - INFO -  |	   FROM mdj.mdj_stlloaderrors_with_null_userid
2017-07-24 12:26:30,398 - INFO -  |	 ;
2017-07-24 12:26:30,559 - INFO -  | End of def main()
2017-07-24 12:26:30,559 - INFO -  +----------------------------------------------------------------------------------------------------+
2017-07-24 12:26:30,559 - INFO -  | Script: /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/LoadTransform.py ENDING
2017-07-24 12:26:30,560 - INFO -  +----------------------------------------------------------------------------------------------------+
(mynewapp) mdjukic@uk179494:/Users/mdjukic/LOG : 
