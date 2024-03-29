#!/bin/bash

echo "Beginning Client Node Setup Script..."

echo "Enter the ip address of the kube-apiserver (if you are running RaaSI in high availability mode this is the VIP of the load balancer):"
read -r master_ip

# validation
val=$(../Validation/checkValidation.sh "$master_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address of the kube-apiserver (if you are running RaaSI in high availability mode this is the VIP of the load balancer): "
        read -r master_ip
        # validation
        val=$(../Validation/checkValidation.sh "$master_ip" 1)
done

master_hostname=$(hostname)
join_command=$(kubeadm token create --print-join-command)

echo "Enter ip address to connect: "
read -r client_ip

# validation
val=$(../Validation/checkValidation.sh "$client_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: IP address was expected"
        echo "Enter ip address to connect: "
        read -r client_ip
        # validation
        val=$(../Validation/checkValidation.sh "$client_ip" 1)
done


echo "Enter username to connect to on the client machine: "
read -r client_user

# validation
val=$(../Validation/checkValidation.sh "$client_user" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: valid username was expected"
        echo "Enter username to connect to: "
        read -r client_user
        # validation
        val=$(../Validation/checkValidation.sh "$client_user" 2)
done


client_hostname=$(ssh "$client_user"@"$client_ip" 'hostname')

echo "$client_hostname"

echo "Adding client to the /etc/hosts file on the master server..."

sed -i "s/$master_hostname/$master_hostname\\n$client_ip\\t$client_hostname/g" /etc/hosts

echo "Adding the master to the /etc/hosts file on the client server..."

client_host_command="s/$client_hostname/$client_hostname\\\n$master_ip\\\t$master_hostname/g"
echo "$client_host_command"

ssh -t "$client_user"@"$client_ip" "sudo sed -i $client_host_command /etc/hosts"

echo "Creating RaaSI directory on client machine..."

ssh "$client_user"@"$client_ip" "mkdir RaaSI; mkdir Validation"

echo "Transfering clientSideNodeSetup.sh script to client machine..."

scp clientSideNodeSetup.sh "$client_user"@"$client_ip":RaaSI/clientSideNodeSetup.sh
scp ../Validation/checkValidation.sh "$client_user"@"$client_ip":Validation/checkValidation.sh

echo "Making clientSideNodeSetup.sh executable..."

ssh -t "$client_user"@"$client_ip" "sudo chmod +x RaaSI/clientSideNodeSetup.sh; sudo chmod +x Validation/checkValidation.sh"

echo "Executing clientSideNodeSetup.sh on $client_hostname..."

ssh -t "$client_user"@"$client_ip" "cd RaaSI || exit; sudo ./clientSideNodeSetup.sh"

./glusterfsClientSetup.sh "$client_ip" "$client_user"

echo "$client_hostname joining the RaaSI cluster..."

ssh -t "$client_user"@"$client_ip" "sudo $join_command"

lclient_hostname=$(echo "$client_hostname" | awk '{print tolower($0)}')

echo "Enabling device detection on node..."
kubectl label nodes "$lclient_hostname" smarter-device-manager=enabled

echo "Would you like to search for devices on this node (y/n)?"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Would you like to search for devices on this node (y/n)?"
        read -r response
        # validation
        val=$(../Validation/checkValidation.sh "$response" 0)
done


if [[ "Yy" =~ $response ]]; then
	echo "Enter the device that you would like to search for: "
	read -r device

	# validation
	val=$(../Validation/checkValidation.sh "$device" 3)
	while [ "passed" != "$val" ];
	do
        	echo "Unexpected Response: expected device name"
        	echo "Enter the device that you would like to search for: "
       		read -r device
        	# validation 
        	val=$(../Validation/checkValidation.sh "$device" 3)
	done

	device_spaceless=${device// /}
	device_present=$(ssh -t "$client_user"@"$client_ip" "sudo lspci" | grep "$device")
        if [ -z "$device_present" ]; then
        	echo "$device is not present";
        else
        	echo "$device is present"
        	echo "Adding $device as a label to the node..."
        	kubectl label nodes "$client_hostname" device="$device_spaceless"
        fi;
fi
