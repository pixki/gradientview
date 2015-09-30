#!/bin/sh
# @Author: jairo
# @Date:   2015-09-28 12:44:06
# @Last Modified by:   jairo
# @Last Modified time: 2015-09-28 14:53:20

usage(){
	echo "Plots the histogram of HashKeys from a simulation file of NS2"
	echo "Usage: "
	echo "  plotHashKeysDistribution.sh SIM_FILE"
}

if [ ! -e $1 ]; then
	usage
	exit 1
fi


HASHKEYS=`grep "HashKeys:" $1 | cut -d' ' -f 5 | tr "," "\n" | sort -n | uniq -c | sort -rn | gnuplot -e "set boxwidth 0.5; set yrange [0:*]; set style fill solid; plot '< cat -' using 2:1 t 'HashKeyDistribution'; pause mouse keypress;"`
#echo $HASHKEYS_LINES


