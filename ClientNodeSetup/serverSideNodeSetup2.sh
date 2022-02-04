#!/bin/bash

echo "Please enter the IP address of the node to connect to the cluster:"
read nodeIP

echo "Sending the join command to the node at "$nodeIP
kubeadm token create --print-join-command | nc $nodeIP 3333

echo "nodeSetup2.sh complete. Please continue with the localnodesetup2.sh script on the node."
