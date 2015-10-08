#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Author: pixki
# @Date:   2015-09-30 12:17:58
# @Last Modified by:   pixki
# @Last Modified time: 2015-10-08 14:48:37

import sys
import argparse


nodes={}
def main():
	parser=argparse.ArgumentParser()
	parser.add_argument('-f', '--file', type=str, required=True, help='Archivo con los datos')
	parser.add_argument('-d', '--destination', type=int, required=True, help='Nodo destino para el que se calcularán las intersecciones de los filtros Bloom')
	args=parser.parse_args()

	with open(args.file, 'r') as f:
		for line in f:
			fields=line.split(' ')
			n=int(fields[0])
			if len(fields)==2:
				s=[int(x) for x in fields[1].split(",")]
				if not nodes.has_key(n):
					nodes[n]={}

				nodes[n]['set']=set(s)
				#print repr(nodes[n])
			elif len(fields)==3:
				if not nodes.has_key(n):
					nodes[n]={}

				nodes[n]['x']=float(fields[1])
				nodes[n]['y']=float(fields[2])
				#print repr(nodes[n])

	if not nodes.has_key(args.destination):
		print "El destino no se encuentra en la red."
		sys.exit(1)

	lastX=0
	intersecciones=[]
	for (k,v) in nodes.items():	
		if k == args.destination: continue
					
		if lastX == 0:
			lastX = v['x']

		if lastX != v['x']:
			print ""
			lastX=v['x']

		intersecciones.append(v['set'].intersection(nodes[args.destination]['set']))
		print "{0} {1} {2} {3}".format(k,v['x'], v['y'], len(v['set'].intersection(nodes[args.destination]['set'])))

	unionI=set([])
	for i in intersecciones: #intersecciones es una lista de sets
		unionI=unionI | i

	print unionI

if __name__ == '__main__':
	main()



