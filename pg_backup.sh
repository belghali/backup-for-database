#!/bin/bash

backup_dossier='/DB/backup/postgresql'
backup_date=`date +%F`
ret=5
mkdir -p $backup_dossier
echo "PostgreSQL backup for $HOSTNAME"
echo "==============================="
echo $backup_date
echo ;
for database in `/usr/bin/psql -U postgres -lt | awk '{print $1}' | grep -vE '\||^$|template0'`
do
        printf "EXPORTING $database...";
        /usr/bin/pg_dump -U postgres -C $database | gzip -c >  $backup_dossier/$database-$backup_date.sql.gz
        #modification des droits pour que l'archive
        /bin/chmod o+rwx $backup_dossier/$database-$backup_date.sql.gz
        printf "done\n";
done
echo ;
#suppression des fichiers au dela de la retention
find $backup_dossier -mtime $ret -delete
#CONSTANTES D'ENVOI FTP
HOST='ftp.hebergratuit.net'
LOGIN='heber_24226304'
PASSWORD='6X2o02berA'
PORT='21'
dossier_destination='htdocs'
#TRANSFERT
echo "Transfert des fichiers vers le serveur"
echo ;
cd $backup_dossier
for fich in `ls $backup_dossier | grep $backup_date`
do
	ftp -i -n $HOST $PORT << END_SCRIPT 
	quote USER $LOGIN
	quote PASS $PASSWORD
	cd $dossier_destination
	binary
	put $fich
	quit
END_SCRIPT
echo "...>Envoi du $fich est au $HOST est fait!"
done
echo "Sauvegarde effectuée"
