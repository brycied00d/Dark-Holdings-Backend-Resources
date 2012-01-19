#!/bin/bash
dom="$1"
user="$2"
exists="$3"
lv="$4"

fulllv="/dev/vg_san/$lv"

if [ -z "$dom" -o -z "$user" -o -z "$exists" -o -z "$lv" ]; then
	echo "Usage: $0 domain user exists lv"
	exit 1
fi 

snaplv="${fulllv}_snap"

if [ $exists -gt 0 ]; then
	dmsetup remove /dev/mapper/vg_san-$dom.darkholdings.com--disk_snap 2>>/var/log/dhproblems.log
	dmsetup remove /dev/mapper/vg_san-$dom.darkholdings.com--disk_snap-cow 2>>/var/log/dhproblems.log
	lvremove $snaplv 2>>/var/log/dhproblems.log 1>/dev/null
fi

snapdate=$(date +%s)

lvcreate --size 1024m --snapshot --name $snaplv $fulllv 2>>/var/log/dhproblems.log 1>/dev/null && echo $snapdate > /home/$user/lastsnap.txt && echo "Snap complete" && exit 0

echo "Unable to create snapshot, please contact the administrator"
