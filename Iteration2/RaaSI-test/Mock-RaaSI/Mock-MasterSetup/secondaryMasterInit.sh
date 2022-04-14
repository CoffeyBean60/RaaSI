#!/bin/bash

echo "Beginning Secondary Master Node Installation..."

echo "Enter the IP of the Master Node that you want to setup: "
master_ip=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$master_ip" 1 >> results/secondaryMasterInitMasterIp

echo "Enter a user with ssh privileges on the Master Node: "
master_user=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$master_user" 2 >> results/secondaryMasterInitMasterUser

echo "Node added to RaaSI"
