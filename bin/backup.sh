#!/bin/bash

# server backup

# init
Log=0
Debug=0

[[ $Log > 0 ]] && printf "[Log($Log)] Demarrage\n" >&2

RSYNCSRC='/var/www/html/nextcloud'
RSYNCDEST='/home/backup-nextcloud'

if [[ ! -d $RSYNCDEST ]]
then
	echo $RSYNCDEST n\'existe pas ! >&2
	if [ $Debug > 0 ]
	then
		printf "[Debug($Debug)] sudo mkdir $RSYNCDEST\n" >&2
		mkdir $RSYNCDEST
	fi
else
	[[ $Log > 0 ]] && printf "[Log($Log)] $RSYNCDEST existe\n" >&2
fi

# mode maintenance on
if [[ $Debug > 0 ]]
then
	printf "[Debug($Debug)] sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --on\n" >&2
else
	sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --on >&2
fi

#BackupDate=`date +"%Y%m%d"`
BackupDate=`date +"%Y%m"`
RSYNCDEST=$RSYNCDEST/nextcloud-dirbkp_$BackupDate

[[ $Log > 0 ]] && printf "[Log($Log)] RSYNCDEST=$RSYNCDEST\n" >&2

# copy the full nextcloud path
if [[ $Debug > 0 ]]
then
	printf "[Debug($Debug)] sudo sh -c \"rsync -Aavx --delete $RSYNCSRC/ $RSYNCDEST/ >> $RSYNCDEST.lst\"\n" >&2
else
	sudo sh -c "rsync -Aavx --delete $RSYNCSRC/ $RSYNCDEST/ >> $RSYNCDEST.lst"
fi


# dump bdd

if [[ $Debug > 0 ]]
then
	printf "[Debug($Debug)] sudo sh -c \"mysqldump --single-transaction -u root nextcloud > $RSYNCDEST.bak\"\n" >&2
else
	sudo sh -c "mysqldump --single-transaction -u root nextcloud > $RSYNCDEST.bak"
fi

# mode maintenance off
if [[ $Debug > 0 ]]
then
	printf "[Debug($Debug)] sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --off\n" >&2
else
	sudo -u www-data php /var/www/html/nextcloud/occ maintenance:mode --off >&2
fi

# restore
# rsync -Aax nextcloud-dirbkp/ nextcloud/
# mysql -h [server] -u [username] -p[password] -e "DROP DATABASE nextcloud"
# mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud"
# ou mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
# mysql -h [server] -u [username] -p[password] [db_name] < nextcloud-sqlbkp.bak
