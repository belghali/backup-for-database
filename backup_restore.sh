
#!/bin/bash
backup_dossier=/DB/downloads
echo "Veuillez entrer la date des backups à récupérer au format aaaa-mm-jj"
read date
mkdir -p $backup_dossier
HOST='############'
LOGIN='###########'
PASSWORD='########'
PORT='##'
dossier_source='htdocs'
ftp -i -n $HOST $PORT << END_SCRIPT
quote USER $LOGIN
quote PASS $PASSWORD
binary
cd $dossier_source
pwd
lcd $backup_dossier
mget *"$date"*
quit
END_SCRIPT
echo "Récupération efféctuée"
echo ;
echo "Extraction des fichiers télechargés"
cd $backup_dossier
for zip in *.zip
do
	unzip $zip
	rm -f $zip
done
for gz in *.gz
do
	if gunzip -f $gz;then
		rm -f $gz
	else
		echo "le fich $gz n'est pas décompressé"
	fi
done
echo "Restauration effectuée"
