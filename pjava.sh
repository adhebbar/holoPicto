#!/bin/bash
rm -rf /tmp/processing
mkdir /tmp/processing
/home/duvvuripratyusha/Desktop/processing-2.0b8/processing-java --output=/tmp/processing/ --force --sketch=$1 --run
