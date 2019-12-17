# server backup

# init
RSYNCSRC='/var/www/html/nextcloud'
RSYNCDEST='/home/backup-nextcloud'

sudo mkdir $RSYNCDEST

# mode maintenance
sudo -u www-data php occ maintenance:mode --on

# copy the full nextcloud path
rsync -Aavx "$RSYNCSRC/" $RSYNCDEST/nextcloud-dirbkp_`date +"%Y%m%d"`/

