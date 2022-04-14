#!/bin/bash

echo "Beginning GlusterFS setup script..."

echo "Enter the ip address for Storage1: "
storage_ip=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$storage_ip" 1 >> results/GlusterInstallationMasterStorageIp

echo "Setting up GlusterFS on Storage1..."
echo "Enter user to connect to on Storage1: "
client_user=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$client_user" 2 >> results/GlusterInstallationMasterClientUser

