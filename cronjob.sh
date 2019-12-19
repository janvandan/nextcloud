# crontab -u www-data -e
*/5  *  *  *  * php -f /var/www/html/nextcloud/cron.php

# crontab -u www-data -l
*/5  *  *  *  * php -f /var/www/html/nextcloud/cron.php
