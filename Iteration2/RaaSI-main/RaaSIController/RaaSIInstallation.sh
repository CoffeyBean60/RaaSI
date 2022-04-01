#!/bin/bash

echo "Welcome to RaaSI Component Installation"
echo "Please select an option below:"
echo "1. Install Load Balancers"
echo "2. Install Primary Master Controller"
echo "3. Install Backup Master Controllers"
echo "4. Install GlusterFS Persistence Volume"
echo "5. Install Worker Nodes"
echo "6. Return to RaaSI Welcome Page"
read result

if [[ "1" == "$result" ]]; then
	echo "Executing Install Load Balancers";
elif [[ "2" == "$result" ]]; then
	echo "Executing Install Primary Master Controller"
	../MasterNodeSetup/masterSetup.sh;
elif [[ "3" == "$result" ]]; then
	echo "Executing Install Backup Master Controllers";
elif [[ "4" == "$result" ]]; then
	echo "Executing Install GlusterFS Persistence Volume"
	../GlusterSetup/GlusterInstallationMaster.sh;
elif [[ "5" == "$result" ]]; then
	echo "Executing Install Worker Nodes"
	../ClientNodeSetup/serverSideNodeSetup.sh;
elif [[ "6" == "$result" ]]; then
	clear
	echo "Returning to RaaSI Welcome Page"
	./RaaSIController.sh
	exit 0;
else
	clear
	echo "Incorrect Option"
	./RaaSIInstallation.sh
	exit 0;
fi
echo "Exiting RaaSI Component Installation..."
./RaaSIController.sh
