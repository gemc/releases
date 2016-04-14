#!/bin/csh -f

# Argument:
set mi   = $1  # Mirror Number
set type = $2  # Mirror Type (EL or HP)

set foci = "";

if($type == "EL") set foci = "../el_foci.txt"
if($type == "HP") set foci = "../hp_foci.txt"

set xf = (`cat $foci | awk '{print $1}'`)
set yf = (`cat $foci | awk '{print $2}'`)


set x = $xf[$mi]
set y = $yf[$mi]

echo $type Mirror $mi foci "  x: "$x"  y: "$y

sed s/"99, 99"/"$x, $y"/ test_mirror.gcard > aaa
sed s/"LTCC88"/"LTCC\_$type\_Mirrors"/ aaa   > mirror_$type"_"$mi".gcard"
rm -rf aaa 


