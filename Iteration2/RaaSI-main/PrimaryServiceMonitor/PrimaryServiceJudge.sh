#!/bin/bash

echo "Script for checking the health of the primary service"

echo "Enter the ip address of the server hosting the primary service: "
read -r server_ip

# validation
val=$(../Validation/checkValidation.sh "$server_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address of the server hosting the primary service: "
        read -r server_ip
        # validation
        val=$(../Validation/checkValidation.sh "$server_ip" 1)
done

echo "Enter the username of a user with ssh permissions on the primary server: "
read -r server_user

# validation
val=$(../Validation/checkValidation.sh "$server_user" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected username"
        echo "Enter the username of a user with ssh permissions on the primary server: "
        read -r server_user
        # validation
        val=$(../Validation/checkValidation.sh "$server_user" 2)
done

echo "Enter the name of the primary service: "
read -r serviceName

# validation
val=$(../Validation/checkValidation.sh "$serviceName" 3)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Enter the name of the primary service: "
        read -r serviceName
        # validation
        val=$(../Validation/checkValidation.sh "$serviceName" 3)
done

echo "Have you already established a shared ssh key between the master node and the primary service? (Y/N)"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already established a shared ssh key between the master node and the primary service? (Y/N)"
        read -r response
        # validation
        val=$(../Validation/checkValidation.sh "$response" 0)
done

if [[ "Yy" =~ $response ]]; then
        echo "SSH key gen complete.";
else
        echo "Setting up shared ssh key to primary service..."
        ssh-keygen -t rsa -b 4096 -C "RaaSI key@$server_ip"
        ssh-copy-id "$server_user"@"$server_ip"
        echo "SSH key gen complete.";
fi
while :
do
	./PrimaryServiceCheck.sh "$server_ip" "$server_user" "$serviceName" &
done


