#!/bin/bash

echo "Script for checking the health of the primary service"

echo "Enter the ip address of the server hosting the primary service: "
read server_ip

echo "Enter the username of a with ssh permissions on this server: "
read server_user

echo "Enter the name of the primary service: "
read serviceName

local_ip=$(hostname -i)
local_user="cybears"

echo "Have you already established a shared ssh key between the master node and the primary service? (Y/N)"
read response
if [[ "Yy" =~ "$response" ]]; then
        echo "SSH key gen complete.";
else
        echo "Setting up shared ssh key to primary service..."
        ssh-keygen -t rsa -b 4096 -C "RaaSI key@$server_ip"
        ssh-copy-id $server_user@$server_ip
        echo "SSH key gen complete.";
fi

./PrimaryServiceCheck.sh $server_ip $server_user $serviceName



