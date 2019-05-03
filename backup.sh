BACKUPTIME=`date +%b-%d-%y`

servers=( "0.0.0.0") ## Array with the servers to perform the backup
USER=dbuser
PASS=dbpassword
## I recommend creating a user on all databases with the same login and password only for backup, preferably with permission only for the backup server
DAY=$(date +"%A")


        if [ "$DAY" = "Wednesday" ] ## remove this if you do not want weekly self-removal of the backup 
        then
                rm -r /var/www/backups
                mkdir /var/www/backups
        fi ## finish if

        for i in "${servers[@]}"
        do
                TEMPDEST=/var/www/backups/$i/backup-$BACKUPTIME ##destiny backups
                mkdir /var/www/backups/$i ## create folder of server
                mkdir $TEMPDEST
                mkdir $TEMPDEST/DB ## create folder for dumps
                scp -r root@$i:/var/www $TEMPDEST ## backup of projects, is optional if you use versioning. But I recommend in the case of wordpress projects where images are saved locally.
                DBS=$(mysql --user=${USER} -h ${i} --password=${PASS}  -e 'show databases;' | awk '{ print $1 }') ##get databases list
                arrDBS=($DBS) 

                for d in "${arrDBS[@]}"
                do
                        SQLFILE=$d-${BACKUPTIME}.sql
                        SQLDEST=$TEMPDEST/DB/${SQLFILE}
                        mysqldump --opt -h ${i} --user=${USER} --password=${PASS} ${d} > ${SQLDEST}
                done

        tar -rf ${TEMPDEST}.tar ${TEMPDEST}/ ##Create uniq archive for backup
        sudo rm -r ${TEMPDEST}
        done
