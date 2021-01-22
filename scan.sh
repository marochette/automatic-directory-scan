#!/bin/bash

set -e

if [ -z "$1" ]
then
	echo "No directory to watch in your line arguments"
	exit 0
fi

inotifywait -m -r -q -e close_write --format '%w%f' $1 |
while read full_filename;
do
	filename=$(basename $full_filename)
	scan_log=$(clamscan $full_filename)
	count_infected=$(echo "$scan_log" | grep "Infected" | cut -d " " -f3)
	if [[ $count_infected -eq 0 ]]
	then
		notify-send "File $filename not infected!"
	else
		notify-send "File $filename are infected"
		zenity --info --text="$filename are infected"
	fi
done
