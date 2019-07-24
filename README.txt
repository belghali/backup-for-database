# backup-for-a-ftp-server
This script shell is about to make a backup for a data base (e.g postgreSQL) and send it to a ftp server
Things to have for that script execute as well:
~Working under linux OS (of course);
~Some databases in PostgreSQL;
~Ftp server.
How it works :
~FOR pg_backup.sh:
~~Compressing the databases into a .gz file and put them in a folder called "backup", then copy them to a folder called "server" which is going to send to ftp server. After uploading the backups, the content of the folder "server" is removed. The script also deletes backups that are older than the specified retention.
~FOR ms_backup.sh
~~the same thing as pg_back.sh expect the fact that ms_backup.sh send compressed files directly to the ftp server one per one
 without creating another folder
 N.B:
~Some words in this script are written in french.
