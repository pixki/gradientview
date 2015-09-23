#!/usr/bin/python
# -*- coding: utf-8 -*- 

import argparse
import sys

#Distancia de separación entre nodos
STEP=150.0

def main(argv):
	parser = argparse.ArgumentParser()
	parser.add_argument('-x', '--xdim', type=int, required=True, help='Nodos en el lado X')
	parser.add_argument('-y', '--ydim', type=int, required=True, help='Nodos en el lado Y')
	args=parser.parse_args()

	node=0

	for i in range(args.xdim):
		for j in range(args.ydim):
			print "$node({0}) set X_ {1}".format(node, (i*STEP)+5)
			print "$node({0}) set Y_ {1}".format(node, (j*STEP)+5)
			print "$node({0}) set Z_ 0.0".format(node)
			print ""

			node=node+1


if __name__ == '__main__':
	main(sys.argv)