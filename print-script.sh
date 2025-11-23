#!/bin/sh

mkdir -p stl
for MODEL in $(cat "$1" | grep BOB_SCAD_PRINT | cut -d' ' -f3-); do
  openscad -D "print=true;${MODEL}()" -o "stl/${MODEL}.stl" "$1"
done
