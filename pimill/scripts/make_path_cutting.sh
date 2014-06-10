#!/bin/bash
png_path $1 $2 1.1 0.79 1 0.5 0.5 0.5 -0.6 -1.7 0.6
path_eps $2 $2.eps
convert $2.eps $2.png