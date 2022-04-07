#!/bin/bash

echo "Entering update labels script..."

echo "Enter the device that you are trying to find on the node machines: "
read -r device

device_spaceless=${device// /}

echo "Would you like to go through all node IP addresses (y/n)?"
read -r response

if [[ "Yy" =~ $response ]]; then
	echo "Getting all node IP addresses..."
	mapfile -t node_ip < <(kubectl get nodes -o wide | awk -v x=6 '{if(NR!=1 && $3!="control-plane,master") print $x}')
	mapfile -t node_name < <(kubectl get nodes -o wide | awk -v x=1 '{if(NR!=1 && $3!="control-plane,master") print $x}');
else
	echo "Enter the IP address of the node that you want to update: "
	read -r node_ip
	mapfile -t node_name < <(kubectl get nodes -o wide | awk -v src="${node_ip[0]}" '{if($6==src) print $1}')
	echo "The node name associated with ${node_ip[0]} is ${node_name[0]}";
fi

index=0

for i in "${node_ip[@]}"
do
	echo "Would you like to search $i for the device, $device (y/n)?"
	read -r response
	if [[ "Yy" =~ $response ]]; then
		echo "Enter a ssh user for $i : "
		read -r user

		echo "Searching for $device on $i..."
		echo "Please note that you will need to enter the password for $user twice."
		device_present=$(ssh -t "$user"@"$i" "sudo lspci" | grep "$device")
		if [ -z "$device_present" ]; then
			echo "$device is not present";
		else
			echo "$device is present"
			echo "Adding $device as a label to the node..."
			kubectl label nodes "${node_name[$index]}" device="$device_spaceless"
		fi;
	fi
	index=$((index+1))
done
