#!/bin/bash

echo "Testing the PSM API stays functional when a master node is down."

echo "Enter the RMN2 user:"
read -r rmn2_user

echo "Enter the RMN2 IP:"
read -r rmn2_ip

echo "Enter the PSN user:"
read -r psn_user

echo "Enter the PSN IP:"
read -r psn_ip

echo "Enter the deployment name:"
read -r deployment

ssh -t "$rmn2_user"@"$rmn2_ip" "sudo poweroff"

sleep 30

echo "Shutting primary service down."

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl stop apache2"

sleep 15

kubectl get deployment "$deployment"

echo "Starting primary service back up."

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl start apache2"

sleep 15

kubectl get deployment "$deployment"
