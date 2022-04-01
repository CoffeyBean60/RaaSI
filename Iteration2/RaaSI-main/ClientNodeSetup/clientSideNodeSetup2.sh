#!/bin/bash

echo "Beginning to join node to the master cluster."

echo "Please run nodeSetup2.sh on the master server."
echo "Your IP address is " $(hostname -i)

join=$(nc -w 10 -l 3333)

echo $join

$join

echo "Congragulations, you have finished setting up this node."
