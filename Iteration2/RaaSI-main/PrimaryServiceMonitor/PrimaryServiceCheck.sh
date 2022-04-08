#!/bin/bash

echo "Script for checking the health of the primary service"

server_ip=$1
server_user=$2
serviceName=$3
command1="systemctl status $serviceName | grep -q 'running' && echo $?"
command2="systemctl status $serviceName | grep -q 'dead' && echo $?"

while :
do
	echo "Checking health of $serviceName"
	serviceStatus=$("$command1" | ssh "$server_user"@"$server_ip")
	if [ -z "$serviceStatus" ]; then
		echo "$serviceName has died"
		break;
	else
		echo "$serviceName is running";
	fi
	sleep 20
done

while :
do
        echo "Checking health of $serviceName"
        serviceStatus=$("$command2" | ssh "$server_user"@"$server_ip")
        if [ -z "$serviceStatus" ]; then
                echo "$serviceName is running"
                break;
        else
                echo "$serviceName is dead";
        fi
        sleep 20
done
