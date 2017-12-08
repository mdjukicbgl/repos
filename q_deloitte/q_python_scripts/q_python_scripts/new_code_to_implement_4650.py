

# validate that staging source table exists
# - validate that it is present in database via pg_table_def say
# ** Check with Chris if the Target schemaname/tablename details are to be held anywhere, if not, then maybe another 

def isStageTablePresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'stage' and table = '" + tablename + "'")
    resultrow = cursor.fetchone()
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 


def isTargetTablePresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'target' and table = '" + tablename + "'")
    resultrow = cursor.fetchone()
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 


def getMaxBatchIdInTarget():
	cursor.execute("SELECT MAX(BATCHID) AS resultmaxbatchid FROM target.tablename")
	resultrow = cursor.fetchone()
    return(resultrow['resultmaxbatchid'])


def insertTargetData(batchid):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM stage.tablename where batch_id > batchid")
    for row in cursor:
       print(row)
       
    
   
    
get max batchid from target table - this provides the load baseline
 - select max(batchid)
     from target.tablename

read all records from stage.tablename where batchid > target.batchid    

---------------------------------------------------------------------------------------------------
! /usr/bin/env python
import mysql.connector
con=mysql.connector.connect(user='root', password ='root', database='test')
cur=con.cursor()

sel=("select id, custName, nSql from TBLA")
cur.execute(sel)
res1=cur.fetchall()

for outrow in res1:
    print 'Customer ID : ', outrow[0], ': ', outrow[1]
    nSql = outrow[2]
    cur.execute(nSql)
    res2=cur.fetchall()

    for inrow in res2:
        dateK =inrow[0]
        id= inrow[1]
        name= inrow[2]
        city=inrow[3]
        insertstmt=("insert into TBLB (dateK, id, name, city) values ('%s', '%s', '%s', '%s')" % (dateK, id, name, city))
        cur.execute(insertstmt)

con.commit()
con.close()


#OK, here's the simpliest version of try:except: block for your case:

# some code
for inrow in res2:
    # some code
    try:
        cur.execute(insertstmt)
    except MySQLdb.ProgrammingError:
        pass
#That's pretty much it. You probably want to know which queries failed, so you should use for example that version:

    try:
        cur.execute(insertstmt)
    except MySQLdb.ProgrammingError:
        print "The following query failed:"
        print insertstmt




#
# start of mainline.....
#
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-b",
        "--batchid",
        help="The Batch Id of the process being passed",
        type=int)
    
    parser.add_argument(
        "-t",
        "--transform",
        help="The name of the transform to load",
        type=str)
    
    parser_args = parser.parse_args(args)
    
    if not (vars(parser_args))['batchid']:
        parser.print_help()
        sys.exit(1)

    #if not (vars(parser_args))['transform']:
    #    parser.print_help()
    #    sys.exit(1)    
    
    aws_batchid = str(parser_args.batchid)
    aws_transform = str(parser_args.transform)
    
    main(sys.argv[1:])
#
# That's all Folks!!!!
#
