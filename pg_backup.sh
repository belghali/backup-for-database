#!/bin/bash

backup_dossier='/DB/backup'
backup_date=`date +%F`
ret=5
backup_server='/DB/server'
mkdir -p $backup_dossier
mkdir -p $backup_server
echo "PostgreSQL backup for $HOSTNAME"
echo "==============================="
echo $backup_date
for database in `/usr/bin/psql -U postgres -lt | awk '{print $1}' | grep -vE '\||^$|template0'`
do
        printf "EXPORTING $database...";
        /usr/bin/pg_dump -U postgres -C $database | gzip -c > $backup_dossier/$database-$backup_date.sql.gz

        #modification des droits pour que l'archive soit lu par tous les utilisateurs
        /bin/chmod o+rwx $backup_dossier/$database-$backup_date.sql.gz
        printf "done\n";
done
echo ;
#suppression des fichiers au dela de la retention
find $backup_dossier -mtime $ret -delete
#copie des fichiers vers le dossier à envoyer sur le serveur ftp
find $backup_dossier -name "*$backup_date.sql.gz" -exec cp {} $backup_server/ \;
#CONSTANTES D'ENVOI FTP
HOST='###"'
LOGIN='####'
PASSWORD='####'
PORT='###'
dossier_destination='htdocs'
#TRANSFERT
ftp -i -n $HOST $PORT << END_SCRIPT 
quote USER $LOGIN
quote PASS $PASSWORD
cd $dossier_destination
lcd $backup_server
pwd
bin
mput *.sql.gz
quit
END_SCRIPT
#suppression des fichiers à envoyer du dossier serveur
find $backup_server -name "*$backup_date.sql.gz" -exec rm -f {} \;
