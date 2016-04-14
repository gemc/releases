#!/bin/csh -f

# The first argument is always the filename
# possible values for the input:
#
# pars  hyperbole or ellipsoid parameters
# foci  focal points
#
# The output is the second argument filename.txt (e.g. foci.txt)

set filaneme = $1
set argument = $2


set what = '';

if($argument == "pars")   set what = 'turn'
if($argument == "foci")   set what = 'f1,f2'
if($argument == "axis")   set what = 'a,b'
if($argument == "center") set what = 'Elliptica'
if($argument == "alpha")  echo "do by hand look file" # rm alpha.txt ; grep degrees elfseek.dat | awk -F"degrees" '{print $2}' > alpha.txt 


rm -f $what.txt
grep -A1 $what $filaneme | grep -v $what | grep -v "\-\-" > $argument.txt







