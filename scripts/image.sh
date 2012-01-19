#!/bin/bash
slice="$1"
user="$2"
if [ -z $1 ]; then
	echo "You need to provide a slice name"
	exit 1
fi
if [ -z $2 ]; then
	echo "You need to provide a user name"
	exit 1
fi

user_details=$(cat /home/$2/slices.txt)

os=$(echo $user_details |cut -d':' -f2)
ip=$(echo $user_details |cut -d':' -f3)

if [ $os == "arch" ]; then
	method="copy"
	installsrc="/store/images/archlinux_2.img"
else
	method=""
	installsrc=""
fi

dhremoveslice $slice

dhinstall $slice $ip interactive $os $method $installsrc

echo "User $user has reimaged their slice with os $os" |mail -s "User Reimaged" zetas@zet.as
