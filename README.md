# gradientview
Scripts and configuration files to generate and display animations of the gra-
dient made by the BFG protocol

Scripts description
===================

* generate_grid.py
Creates a network, where the nodes are layout in an square or rectangle grid. 
The output should be redirected to the desired file.
Parameters:

  * -x How many columns (width) the grid will have
  * -y How many rows (height) the grid will have

* gridsim.tcl
Simulation file for NS2.34 with the BFG protocol used to run the simulation 
and printing the necessary values. The output should be redirected to the 
desired file.

* parse.sh
Last step, this file parses and analyzes the data printed by the simulation
plotting the results, and finally creating an animation with the plotted 
data. Needs GNUPlot and FFMpeg binaries.



Experiment description
===============================

*Effect of D-parameters in the probabilistic gradient

The D-parameters are values that have direct effect in the degradation
of the Bloom filters, this values are the degradation probability, and
the ratio of degradation. 

For this experiment, the values of T-parameters (timers) are fixed to 
previously observed values where the gradient remains stable through time,
this values are:
   *Hello Interval: 5 segundos
   *Degradation interval: 10 segundos

