#!/bin/bash

echo "Enter ip address to connect: "
client_ip=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$client_ip" 1 >> results/serverSideNodeSetupClientIp

echo "Enter username to connect to: "
client_user=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$client_user" 2 >> results/serverSideNodeSetupClientUser

echo "Would you like to search for devices on this node (y/n)?"
response=$3

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/serverSideNodeSetupResponse

if [[ "Yy" =~ $response ]]; then
	echo "Enter the device that you would like to search for: "
	device=$4

	# validation
	../../../RaaSI-main/Validation/checkValidation.sh "$device" 3 >> results/serverSideNodeSetupDevice
fi
