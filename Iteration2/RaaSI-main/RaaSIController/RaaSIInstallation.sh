#!/bin/bash

echo "Welcome to RaaSI Component Installation"
echo "Please select an option below:"
echo "1. Install Load Balancers"
echo "2. Install Primary Master Controller"
echo "3. Install Backup Master Controllers"
echo "4. Install GlusterFS"
echo "5. Install Worker Nodes"
echo "6. Return to RaaSI Welcome Page"
read -r result

if [[ "1" == "$result" ]]; then
	echo "Executing Install Load Balancers"
	cd ../LoadBalancerSetup
	./LBInstallation.sh
	cd ../RaaSIController;
elif [[ "2" == "$result" ]]; then
	echo "Executing Install Primary Master Controller"
	cd ../MasterNodeSetup
	./masterSetup.sh
	cd ../RaaSIController;
elif [[ "3" == "$result" ]]; then
	echo "Executing Install Backup Master Controllers"
	cd ../MasterNodeSetup
	./secondaryMasterInit.sh
	cd ../RaaSIController;
elif [[ "4" == "$result" ]]; then
	echo "Executing Install GlusterFS"
	cd ../GlusterSetup
	.GlusterInstallationMaster.sh
	cd ../RaaSIController;
elif [[ "5" == "$result" ]]; then
	echo "Executing Install Worker Nodes"
	cd ../ClientNodeSetup
	./serverSideNodeSetup.sh
	cd ../RaaSIController;
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
