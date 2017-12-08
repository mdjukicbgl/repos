#!/bin/env bash
 
#
# Define the steps dir, where *sql objects reside
#
STEPSDIR=${HOME}/repos/steps
ALIGNDIR=${HOME}/repos/align
 
#
# Get last HWM written, and only rollback from this point
#
LASTHWM=$(cat ${ALIGNDIR}/dbalignHWM.log)
 
#
# Rollback DDL build
#
clear
printf '=%.s' {1..100}| tr '=' '-'; printf '\n'
printf 'Rolling back database objects.....'; printf '\n'
printf '=%.s' {1..100}| tr '=' '-'; printf '\n'
 
for i in $(ls -1 ${STEPSDIR}/*sql| grep rollback| sort -r)
        do
                if [ $(basename $i | cut -d '_' -f1 ) -le "${LASTHWM}" ]
                then
                        basename $i
                        ssh ec2-user@ip-172-31-37-188 "source ~/bigdataconfig.py; psql \-q --host=\${redshifthostname} --port=\${redshiftport} --username=\${myredshiftusername} --dbname=\${myredshiftdbname} -f $i "
                fi
        done
 
#
# Execute DDL build
#
printf '=%.s' {1..100}| tr '=' '-'; printf '\n'
printf 'Building database objects.....'; printf '\n'
printf '=%.s' {1..100}| tr '=' '-'; printf '\n'
 
for i in $(ls -1 ${STEPSDIR}/*sql| grep -v rollback| sort)
        do      basename $i
                ssh ec2-user@ip-172-31-37-188 "source ~/bigdataconfig.py; psql \-q --host=\${redshifthostname} --port=\${redshiftport} --username=\${myredshiftusername} --dbname=\${myredshiftdbname} -f $i "
        done
 
printf '=%.s' {1..100}| tr '=' '-'; printf '\n'
 
#
# capture last step created, as high-watermark for next time
#
echo $(basename $i) | cut -d '_' -f1 > ${ALIGNDIR}/dbalignHWM.log
