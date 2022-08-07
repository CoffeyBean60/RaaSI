#!/bin/bash

echo "Testing if an outside node can connect to the RSN."

echo "Enter outside node user:"
read -r o_user

echo "Enter outside node IP:"
read -r o_ip

echo "Enter RSN IP:"
read -r rsn_ip

ssh -t "$o_user"@"$o_ip" "sudo mkdir /gv0; sudo mount -t glusterfs $rsn_ip:/gv0 /gv0"

