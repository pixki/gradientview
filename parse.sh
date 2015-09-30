#!/bin/bash
# @Author: pixki
# @Date:   2015-09-09 12:57:26
# @Last Modified by:   jairo
# @Last Modified time: 2015-09-29 20:21:50

echo "Separando filtros por tiempo desde $1"

TIMES=`grep "pBFG" $1 | cut -d' ' -f 1 | uniq`

TITLE=$2

rm -rf output
mkdir output

STEP=0
for i in $TIMES; do
	LINES=`egrep "^$i .* pBFG" $1`	
	echo "$LINES" > output/$i.out
	ID=`printf %05d $STEP`
	#Agrega saltos de linea cuando cambia de tiempo, para graficarlo en 3D
	awk '{ if(NR == 1){ X=$3; } if($3 != X) { print ""; X=$3; } print $0; } ' output/$i.out > output/$ID.out
	
	#Se grafica unicamente el layout de la red
	gnuplot <<- EOF
		set term pngcairo
		set output "output/node-location.png"
		set title "Node location in the grid"
		plot "output/$i.out" using 3:4:2 with labels offset 1 notitle, "output/$i.out" using 3:4:2 pt 2 notitle
	EOF

	#Se borra el archivo original que no sirve para graficar
	rm output/$i.out
	STEP=$((STEP+1))
done

IMG=0
for j in `find output -name "*.out" | sort`; do
	TIME=`cut -f 1 -d' ' $j | sed "/^$/d" | uniq` 
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
		set cbrange [0:1.0]
		set zrange [0:1.0]
		splot "$j" using 3:4:6 with lines notitle
	EOF
	IMG=$((IMG+1))
done

echo "Creando animacion..."

if [[ ! -z $TITLE || $TITLE != "" ]]; then	
	FILENAME="$TITLE";
else
	FILENAME="animated_gradient"
fi

#-framerate 1/5  = Una imagen cada 5 segundos
#-framerate 2    = Dos imagenes por segundo
ffmpeg -f image2 -framerate 2 -i output/gradient-%05d.png -c:v libx264 -r 30 -pix_fmt yuv420p -y "output/$FILENAME.mp4"

echo "Abriendo resultado"
xdg-open "output/$FILENAME.mp4"



