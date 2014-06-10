#!/bin/bash
x=$(echo "(40.0*$1)/1" | bc) # 40/mm
y=$(echo "(40.0*$2)/1" | bc)
echo "PA;PA;!VZ10;!PZ0,100;PU $x $y;PD $x $y;!MC0;" > rml_move.rml
cat rml_move.rml > $3
rm rml_move.rml