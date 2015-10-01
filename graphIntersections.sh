#!/bin/sh
# @Author: pixki
# @Date:   2015-09-30 14:20:55
# @Last Modified by:   pixki
# @Last Modified time: 2015-09-30 14:38:45

rm -rf "intersection"
mkdir "intersection"

i=0
f=1
while [ $i -lt 720 ]; do
	FILENAME=`printf "%05d" $f`
	./graphHKI.py -f HashKeySet.txt -d 190 | gnuplot -p -e "reset; set term pngcairo enhanced font 'Verdana,9'; set output 'intersection/$FILENAME.png'; set pm3d; set hidden3d; set border 4095; set view 60,$(($i%360)); splot '< cat -' using 2:3:4 notitle;"
	i=$((i+5))
	f=$((f+1))
done

ffmpeg -f image2 -framerate 5 -i intersection/%05d.png -c:v libx264 -r 30 -pix_fmt yuv420p -y "intersection/intersection.mp4"
xdg-open "intersection/intersection.mp4"
