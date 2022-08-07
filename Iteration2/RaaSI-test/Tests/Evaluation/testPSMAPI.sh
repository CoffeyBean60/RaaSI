#!/bin/bash

echo "Testing if primary service is down the correct secondary service gets deployed."

echo "Enter the PSN user:"
read -r psn_user

echo "Enter the PSN IP:"
read -r psn_ip

echo "Enter deployment name:"
read -r deployment

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl stop apache2"

sleep 15

kubectl get deployment "$deployment"

echo "Testing if primary service comes online the correct secondary service gets halted."

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl start apache2"

sleep 15

kubectl get deployment "$deployment"
