#!/bin/bash

echo "Welcome to the RaaSI Primary Service Monitoring Menu"
echo "Please select an option below:"
echo "1. Install the Primary Service Monitoring API"
echo "2. Update the Primary Service Monitoring API"
echo "3. Return to RaaSI Welcome Page"
read -r result

if [[ "1" == "$result" ]]; then
        echo "Executing Install the Primary Service Monitoring API"
        cd ../PrimaryServiceMonitor || exit
	      ./primaryServiceMonitorSetup.sh
	      exit 0;
elif [[ "2" == "$result" ]]; then
        echo "Executing Update the Primary Service Monitoring API"
        cd ../PrimaryServiceMonitor || exit
	      ./primaryServiceMonitorUpdate.sh
	      exit 0;
elif [[ "3" == "$result" ]]; then
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
