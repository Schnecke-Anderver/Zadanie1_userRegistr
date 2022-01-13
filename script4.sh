#!/bin/bash

echo "Enter the fail name: "
read filename

for line in $(cat $filename)
do
	username=`echo $line | cut -d : -f1`
	usergroup=`echo $line | cut -d : -f2`
	userpaswd=`echo $line | cut -d : -f3`
	usershell=`echo $line | cut -d : -f4`
	ssl_paswd=`openssl passwd -1 $userpaswd`
	echo $username

	if [[ `grep $username /etc/passwd` ]] #Need fix
	then
		echo $username "User is registered"
	else
		echo $username "User is missing"
		read -p "Create new user? [y/n] " createUser
		if [[ "$createUser" == [yY] ]]
		then
			echo `groupadd -f $usergroup`
			echo `useradd $username -p $ssl_paswd -g $usergroup -s $usershell`
			echo "User $username is registered now"
		else
			echo "User not created"
		fi
	read -p "Do yu need to make any changes with $username? [y/n] " change
		if [[ "$change" == [yY] ]]
		then
			read -p "Change user $username primary group? [y/n] " changeGroup
			if [[ "$changeGroup" == [yY] ]]
			then
				existingGroup=`groups $username | cut -d : -f2`
				if [[ $existingGroup != $usergroup ]]
				then
					usermod -g $usergroup $username
				else
					echo " User $username is already in the group $usergroup"
				fi
			read -p "Change user $username password? [y/n] " changePasswd
			if [[ " $changePasswd" == [yY] ]]
			then
				usermod -p $ssl_paswd $username
			fi
			read -p "Change user $username shell? [y/n] " changeShell
	if [[ "$changeShell" == [yY] ]]
			then
				existingShfiell=`grep $username /etc/passwd | cut -d : -f7`
				if [[ "$existingShell" != $usershell ]]
				then
					usermod -s $usershell $username
				else
					echo "The shell matches the required"
				fi
			fi
			fi
		fi
	fi

done
