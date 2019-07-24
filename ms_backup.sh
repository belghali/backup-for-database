#!/bin/bash

backup_dossier='/DB/backup/mysql'
backup_date=`date +%F`
ret=5
skip_db='Database|information_schema|performance_schema|mysql'
mkdir -p $backup_dossier/
for database in `/usr/bin/mysql -e 'SHOW DATABASES;' | grep -vE $skip_db`
do
	echo "for" $database
	echo "."
	/usr/bin/mysqldump --skip-lock-tables --events --databases $database | gzip > $backup_dossier/$database~$backup_date.sql.gz
	/bin/chmod o+rwx $backup_dossier/$database~$backup_date.sql.gz
	echo "done"
done
#suppression des fichiers au dela de la retention
find $backup_dossier -mtime $ret -delete
#############
#ftp
HOST='ftp.hebergratuit.net'
LOGIN='heber_24226304'
PASSWORD='6X2o02berA'
PORT='21'
dossier_destination='htdocs'
for fich in `ls $backup_dossier |grep $backup_date`
do
	ftp -i -n $HOST $PORT<<END_SCRIPT
	quote USER $LOGIN
	quote PASS $PASSWORD
	lcd $backup_dossier
	cd $dossier_destination
	put $fich
	quit
END_SCRIPT
echo ".."
	echo "envoi du $fich est fait!"
echo ".."
done
echo "Sauvegarde effectuée"
