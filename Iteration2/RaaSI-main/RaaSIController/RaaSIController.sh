#!/bin/bash

echo "Welcome to RaaSI (Resiliency as a Service Infrastructure)"
echo "Please select an option to continue..."
echo "1. Install RaaSI Components"
echo "2. Monitor Primary Service"
echo "3. Configure RaaSI Cluster"
echo "4. Exit"
read result

if [[ "1" == "$result" ]]; then
	clear
	echo "Navigating to Install RaaSI Components"
	./RaaSIInstallation.sh;
	exit 0;
elif [[ "2" == "$result" ]]; then
	echo "Navigating to Monitor Primary Service";
	../PrimaryServiceMonitor/PrimaryServiceJudge.sh
elif [[ "3" == "$result" ]]; then
	echo "Navigating to Configure RaaSI Cluster";
elif [[ "4" == "$result" ]]; then
	echo "Exiting RaaSI";
else
	clear
	echo "Incorrect option specified..."
	./RaaSIController.sh
	exit 0;
fi

echo "Thank you for using RaaSI"


