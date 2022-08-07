#!/bin/bash

echo "Test for adding file to RSN and seeing if other RWN can view it."

echo "Enter RWN3 User:"
read -r user

echo "Enter RWN3 IP:"
read -r ip

ssh -t "$user"@"$ip" "sudo mkdir /gv0/test"

echo "Enter RWN2 User:"
read -r user

echo "Enter RWN2 IP:"
read -r ip

ssh -t "$user"@"$ip" "ls /gv0/test"

echo "Test for adding file to RSN from Secondary Service and seeing if other RWN can view it."

echo "Enter the name of a pod to access:"
read -r pod

kubectl exec "$pod" -- mkdir /gv0/test2

ssh -t "$user"@"$ip" "ls /gv0/test2"
