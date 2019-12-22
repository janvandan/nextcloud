#!/bin/bash

# server backup
# version 0.2

# init
RSYNCSRC='/var/www/html/nextcloud'
RSYNCDEST='/home/backup-nextcloud'

if [[ ! -d $RSYNCDEST ]]
then
	echo $RSYNCDEST n\'existe pas !
	sudo mkdir $RSYNCDEST
fi

exit

# mode maintenance
sudo -u www-data php occ maintenance:mode --on

# copy the full nextcloud path
rsync -Aavx "$RSYNCSRC/" $RSYNCDEST/nextcloud-dirbkp_`date +"%Y%m%d"`/

# dump bdd

mysqldump --single-transaction -h [server] -u [username] -p[password] [db_name] > $RSYNCDEST/nextcloud-sqlbkp_`date +"%Y%m%d"`.bak


# restore
# rsync -Aax nextcloud-dirbkp/ nextcloud/
# mysql -h [server] -u [username] -p[password] -e "DROP DATABASE nextcloud"
# mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud"
# ou mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
# mysql -h [server] -u [username] -p[password] [db_name] < nextcloud-sqlbkp.bak
