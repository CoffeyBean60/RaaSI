#!/bin/bash

echo "Welcome to RaaSI Component Installation"
echo "Please select an option below:"
echo "1. Install Standard Master Controller"
echo "2. Install Load Balancers"
echo "3. Install Primary Master Controller"
echo "4. Install Backup Master Controllers"
echo "5. Install GlusterFS"
echo "6. Install Worker Nodes"
echo "7. Return to RaaSI Welcome Page"
read -r result

if [[ "1" == "$result" ]]; then
	echo "Executing Install Standard Master Controller"
	cd ../MasterNodeSetup || exit
	./standardMasterNodeSetup.sh
	cd ../RaaSIController || exit;
elif [[ "2" == "$result" ]]; then
	echo "Executing Install Load Balancers"
	cd ../LoadBalancerSetup || exit
	./LBInstallation.sh
	cd ../RaaSIController || exit;
elif [[ "3" == "$result" ]]; then
	echo "Executing Install Primary Master Controller"
	cd ../MasterNodeSetup || exit
	./masterSetup.sh
	cd ../RaaSIController || exit;
elif [[ "4" == "$result" ]]; then
	echo "Executing Install Backup Master Controllers"
	cd ../MasterNodeSetup || exit
	./secondaryMasterInit.sh
	cd ../RaaSIController || exit;
elif [[ "5" == "$result" ]]; then
	echo "Executing Install GlusterFS"
	cd ../GlusterSetup || exit
	./GlusterInstallationMaster.sh
	cd ../RaaSIController || exit;
elif [[ "6" == "$result" ]]; then
	echo "Executing Install Worker Nodes"
	cd ../ClientNodeSetup || exit
	./serverSideNodeSetup.sh
	cd ../RaaSIController || exit;
elif [[ "7" == "$result" ]]; then
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
