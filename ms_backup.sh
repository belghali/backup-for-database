#!/bin/bash

backup_dossier='/DB/backup/mysql'
backup_date=`date +%F`
ret=5
skip_db='Database|information_schema|performance_schema|mysql'
mkdir -p $backup_dossier/
for database in `/usr/bin/mysql -e 'SHOW DATABASES;' | grep -vE $skip_db`
do
	echo -n $database".."
	/usr/bin/mysqldump --databases $database | gzip -c > $backup_dossier/$database~$backup_date.sql.gz
	#modification des droits de l'archive
	/bin/chmod o+rwx $backup_dossier/$database~$backup_date.sql.gz
	echo "done"
done
#suppression des fichiers au dela de la retention
find $backup_dossier -mtime $ret -delete
echo "Transfert des fichiers vers le serveur"
echo ;
#ftp
HOST='ftp.hebergratuit.net'
LOGIN='heber_24226304'
PASSWORD='6X2o02berA'
PORT='21'
dossier_destination='htdocs'
cd $backup_dossier
for fich in `ls $backup_dossier |grep $backup_date`
do
	ftp -i -n $HOST $PORT<<END_SCRIPT
	quote USER $LOGIN
	quote PASS $PASSWORD
	binary
	cd $dossier_destination
	put $fich
	quit
END_SCRIPT
echo "......>Envoi du $fich au $HOST est fait!"
done
echo "Sauvegarde effectuée"
