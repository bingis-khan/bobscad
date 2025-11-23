#!/bin/sh

mkdir -p stl
for MODEL in $(cat "$0".scad | grep BOB_SCAD_PRINT | cut -d' ' -f3-); do
  openscad -D "print=true;${MODEL}()" -o "stl/${MODEL}.stl" keyboard.scad
done
