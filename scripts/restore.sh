#!/bin/bash
dom="$1"
user="$2"
lv="$3"

fulllv="/dev/vg_san/$lv"

if [ -z "$dom" -o -z "$user" -o -z "$lv" ]; then
	echo "Usage: $0 domain user lv"
	exit 1
fi 

snaplv="${fulllv}_snap"

snapdate=$(date +%s)

lvconvert --merge $snaplv 2>>/var/log/dhproblems.log && sleep 3 && lvcreate --size 1024m --snapshot --name $snaplv $fulllv 2>>/var/log/dhproblems.log 1>/dev/null && echo $snapdate > /home/$user/lastsnap.txt && echo "Snap complete" && exit 0

echo "Unable to create restore, please contact the administrator"
