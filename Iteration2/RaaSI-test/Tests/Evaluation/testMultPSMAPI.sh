#!/bin/bash

echo "Testing if a primary service goes down the correct distribution of secondary services is deployed."

echo "Enter PSN user:"
read -r psn_user

echo "Enter PSN IP:"
read -r psn_ip

echo "Enter first deployment:"
read -r deployment1

echo "Enter second deployment:"
read -r deployment2

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl stop apache2"

sleep 15

kubectl get deployment "$deployment1"

kubectl get deployment "$deployment2"

echo "Testing the halting of deployments after healthy primary service."

ssh -t "$psn_user"@"$psn_ip" "sudo systemctl start apache2"

sleep 15

kubectl get deployment "$deployment1"

kubectl get deployment "$deployment2"
