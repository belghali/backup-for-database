#!/bin/bash
backup_date=`date +%F`
backup_dossier='/DB/backup/front'
ret=5
mkdir -p $backup_dossier
if [ $# -eq 1 ]&&[ -f $1 ]; then
	cat $1 | while read ligne
	do
		if [ -d $ligne ];then
			test1=`ls -a $ligne |sed -e "/\.$/d" | wc -l`
			if [ $test1 -ne 0 ]; then
				echo $ligne "est un dossier"
				zip -r $ligne-$backup_date.zip $ligne
				/bin/chmod o+rwx $ligne-$backup_date.zip
				mv $ligne-$backup_date.zip $backup_dossier
			else
				echo $ligne "est un dossier vide"
			fi
		else
			echo $ligne "n'est pas un dossier"
		fi
	done
	find $backup_dossier/ -mtime $ret -delete
	test2=`ls $backup_dossier | head -1`
	if [ -n $test2 ];then
		HOST='ftp.hebergratuit.net'
		LOGIN='heber_24226304'
		PASSWORD='6X2o02berA'
		PORT='21'
		backup_destination='htdocs'
		cd $backup_dossier
		echo "Transfert des fichiers vers le serveur"
		echo ;
		for fich in `ls $backup_dossier | grep $backup_date`
		do
			ftp -i -n $HOST $PORT << END_SCRIPT
			quote USER $LOGIN
			quote PASS $PASSWORD
			binary
			cd $backup_destination
			put $fich
			quit
END_SCRIPT
		echo "...> Envoi du $fich au $HOST est fait!"
		done
		echo "Sauvegarde effectué"
	fi
else
	echo "Paramètre entré non valide"
fi
