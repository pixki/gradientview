#!/bin/bash
# @Author: pixki
# @Date:   2015-09-09 12:57:26
# @Last Modified by:   pixki
# @Last Modified time: 2015-09-11 16:45:09

echo "Separando filtros por tiempo desde $1"

TIMES=`grep "pBFG" $1 | cut -d' ' -f 1 | uniq`

TITLE=$2

rm -rf output
mkdir output

for i in $TIMES; do
	LINES=`egrep "^$i .* pBFG" $1`
	echo "$LINES \n" > output/$i.out
	awk '{ if(NR == 1){ X=$3; } if($3 != X) { print ""; X=$3; } print $0; } ' output/$i.out > output/$i-f.out
	gnuplot <<- EOF
		set term pngcairo
		set output "output/node-location.png"
		set title "Node location in the grid"
		plot "output/$i.out" using 3:4:2 with labels offset 1 notitle, "output/$i.out" using 3:4:2 pt 2 notitle
	EOF
	rm output/$i.out
done

IMG=0
for j in `find output -name "*.out"`; do
	TIME=`echo "$j" | sed "s/output\///"` 
	TIME=`echo "$TIME" | sed "s/-f.out//"`	
	TIME=`printf %.2f $(echo "$TIME" | bc -l)`
	IDX=`printf %05d $IMG`
	gnuplot <<- EOF
	    reset
		set term pngcairo enhanced font 'Verdana,9'
		set output "output/gradient-$IDX.png"
		#set pm3d at st
		set pm3d implicit at b
		set hidden3d
		set border 4095
		set samples 25
		set isosamples 20
		set title "$TITLE t=$TIME"
		set cbrange [0.8:1.0]
		set zrange [0.8:1.0]
		splot "$j" using 3:4:6 with lines notitle
	EOF
	IMG=$((IMG+1))
done

echo "Creando animacion..."
#-framerate 1/5  = Una imagen cada 5 segundos
#-framerate 2    = Dos imagenes por segundo
ffmpeg -f image2 -framerate 2 -i output/gradient-%05d.png -c:v libx264 -r 30 -pix_fmt yuv420p -y output/animated_gradient.mp4

echo "Abriendo resultado"
xdg-open output/animated_gradient.mp4



