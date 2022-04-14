#!/bin/bash

echo "Entering update labels script..."

echo "Enter the device that you are trying to find on the node machines: "
device=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$device" 3 >> results/updateLabelsDevice

echo "Would you like to go through all node IP addresses (y/n)?"
response=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/updateLabelsResponse

echo "Enter the IP address of the node that you want to update: "
node_ip=$3

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$node_ip" 1 >> results/updateLabelsNodeIp
