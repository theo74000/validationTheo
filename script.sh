
#check si vagrant et virtualbox sont installer
echo -e "\033[32mVerification si vagrant est installer \033[0m"
if ( dpkg-query -W -f='${Status}' vagrant 2>/dev/null); then
	echo ""
else
	echo "vagrant n'est pas intaller"
fi

echo -e "\033[32mVerification si virtualbox est installer \033[0m"
if  dpkg-query -W -f='${Status}' virtualbox 2>/dev/null; then
	echo ""
else
	echo "virtualbox pas installer"
fi

#choix de la box
choixbox="z"
box="n"
while [[ $choixbox != "a" ]] && [[ $choixbox != "b" ]]; do
	echo -e "\033[32mChoissir une box \033[0m"
	echo -e "a. ubuntu/xenial64"
	echo -e "b. ubuntu/xenial64"
	read choixbox

	if [[ $choixbox == "a" ]]; then

		box='ubuntu/xenial64'

	elif [[ $choixbox == "b" ]]; then

		box='ubuntu/xenial64'
	fi
done

#config des dossiers de la box
echo -e "\033[32mComment voulez-vous appeler vos dossier de base local ? (data)\033[0m"
read data
echo -e "\033[32mComment voulez-vous appeler vos doosiers synchro? (var/www/html)\033[0m"
read synchro


#recapitulatif de la box
echo -e "Vous avez choisi la box" $box
echo -e "Votre dossier local est" $data
echo -e "Votre dossier distant est" $synchro


#validation de la config
confirm="a"
while [[ $confirm != "oui" ]] && [[ $confirm != "non" ]]; do
	echo -e "\033[32mVoulez-vous valider la config de la box ? (oui/non)\033[0m"
	read confirm

	if [[ $confirm == "oui" ]]; then
		#initialisation du vagrant
		vagrant init

		#supprimer ligne box et remplacer
		sed -i '15d' Vagrantfile
		sed -i '15i\  config.vm.box = "'$box'"' Vagrantfile
		
		#supprimer ligne config network et remplacer
		sed -i '35d' Vagrantfile
		sed -i '35i\  config.vm.network "private_network", ip: "192.168.33.10"' Vagrantfile

		#supprimer ligne config folder et remplacer
		sed -i '46d' Vagrantfile
		sed -i '46i\  config.vm.synced_folder "./'$data'", "/'$synchro'"' Vagrantfile

		vagrant up
		vagrant ssh

		echo -e "\033[32mConfiguration valider\033[0m"
		#afficher les vagrants
		echo -e "\033[32mAffichage des vagrants\033[0m"
		vagrant box list


	elif [[ $confirm == "non" ]]; then
		#relancer le script
		bash script.sh
	fi
done


