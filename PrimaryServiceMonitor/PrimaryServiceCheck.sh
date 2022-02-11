#!/bin/bash

echo "Script for checking the health of the primary service"

echo "Please enter the name of the primary service: "
read serviceName

while :
do
	echo "Checking health of "$serviceName
	serviceStatus=$(systemctl status $serviceName | grep -q 'running' && echo $?)
	echo $serviceStatus
	if [ -z $serviceStatus ]; then
		echo "Primary Service has died"
		exit 1;
	fi
	sleep 20
done


