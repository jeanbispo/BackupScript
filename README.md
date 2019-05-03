# BackupScript

###### ***Open for contributions***


#### It is necessary to configure crontab

`touch /var/log/daily-backup.log`

`crontab -e` -> `00 01  *  *  * /bin/bash /path/backup_script.sh  >> /var/log/daily-backup.log 2>&1`


Crontab set for daily backup at 01:00

