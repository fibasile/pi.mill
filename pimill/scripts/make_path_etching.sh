#!/bin/bash
png_path $1 $2 1.1 0.4 4 0.5 0.5 0.5 -0.1
path_eps $2 $2.eps
convert -density 200 $2.eps $2.png
