#!/bin/bash

echo "Welcome to the RaaSI Configuration Menu"
echo "Please select an option below:"
echo "1. Add Secondary Service"
echo "2. Update Labels on Node(s)"
echo "3. Manually Execute Secondary Service"
echo "4. Manually Halt Secondary Service"
echo "5. Return to RaaSI Welcome Page"
read -r result

if [[ "1" == "$result" ]]; then
        echo "Executing Add Secondary Service"
	../Configuration/addSecondaryService.sh
	exit 0;
elif [[ "2" == "$result" ]]; then
        echo "Executing Update Labels on Node(s)"
	../Configuration/updateLabels.sh
	exit 0;
elif [[ "3" == "$result" ]]; then
        echo "Executing Manually Execute Secondar Service"
	echo "Enter the name of the Secondary Service that you wish to deploy: "
	read -r ss
	deployment="$ss-deployment"
	echo "Enter the device needed on the node to run this service: "
	read -r device
	device_spaceless=${device// /}
	../Configuration/manuallyDeploy.sh "$deployment" "$device_spaceless"
	exit 0;
elif [[ "4" == "$result" ]]; then
        echo "Executing Manually Halt Secondary Service"
        echo "Enter the name of the Secondary Service that you wish to halt: "
        read -r ss
        deployment="$ss-deployment"
        ../Configuration/manuallyHalt.sh "$deployment"
        exit 0;
elif [[ "5" == "$result" ]]; then
        clear
        echo "Returning to RaaSI Welcome Page"
        ./RaaSIController.sh
        exit 0;
else
        clear
	echo "Incorrect Option"
        ./RaaSIConfiguration.sh
        exit 0;
fi

clear
echo "Exiting RaaSI Configuration..."
./RaaSIController.sh
