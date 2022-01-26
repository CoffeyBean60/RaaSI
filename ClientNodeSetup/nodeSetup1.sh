#!/bin/bash

echo "Please enter the ip address of the node that you are trying to connect:"
read nodeIP

echo "Please enter the hostname of the node that you are trying to connect:"
read nodeHostname

myHostname=$(hostname)

echo "Updating /etc/hosts/ with the new nodes' information"
sed -i "s/$myHostname/$myHostname\\n$nodeIP\\t$nodeHostname/g" /etc/hosts

echo "Sending master IP and Hostname to node"
echo $(hostname -i)";"$(hostname) | nc $nodeIP 3333

echo "nodeSetup1.sh complete. Please continue with the localnodesetup1.sh script."
