#!/bin/bash

echo "Beginning GlusterFS setup script..."

echo "Enter the ip address for Storage1: "
read -r storage1_ip

# validation
val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for Storage1: "
        read -r storage1_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
done

echo "Enter the ip address for Storage2: "
read -r storage2_ip

# validation
val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for Storage2: "
        read -r storage2_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
done

echo "Enter the ip address for Storage3: "
read -r storage3_ip

# validation
val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for Storage3: "
        read -r storage3_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
done

echo "Setting up GlusterFS on Storage1..."
echo "Enter user to connect to on Storage1: "
read -r client_user1

# validation
val=$(../Validation/checkValidation.sh "$client_user1" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected username"
        echo "Enter user to connect to on Storage1: "
        read -r client_user1
        # validation
        val=$(../Validation/checkValidation.sh "$client_user1" 2)
done

client_ip="$storage1_ip"

echo "Creating RaaSI directory on Storage1 machine..."
ssh "$client_user1"@"$client_ip" "mkdir RaaSI"

echo "Transfering GlusterInstallationNode.sh script to Storage1..."
scp GlusterInstallationNode.sh "$client_user1"@"$client_ip":RaaSI/GlusterInstallationNode.sh

echo "Making GlusterInstallationNode.sh executable..."
ssh -t "$client_user1"@"$client_ip" "sudo chmod +x RaaSI/GlusterInstallationNode.sh"

echo "Executin GlusterInstallationNode.sh on Storage1..."
ssh -t "$client_user1"@"$client_ip" "sudo RaaSI/GlusterInstallationNode.sh"

echo "Setting up GlusterFS on Storage2..."
echo "Enter user to connect to on Storage2: "
read -r client_user2

# validation
val=$(../Validation/checkValidation.sh "$client_user2" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected username"
        echo "Enter user to connect to on Storage2: "
        read -r client_user2
        # validation
        val=$(../Validation/checkValidation.sh "$client_user2" 2)
done

client_ip="$storage2_ip"

echo "Creating RaaSI directory on Storage2 machine..."
ssh "$client_user2"@"$client_ip" "mkdir RaaSI"

echo "Transfering GlusterInstallationNode.sh script to Storage2..."
scp GlusterInstallationNode.sh "$client_user2"@"$client_ip":RaaSI/GlusterInstallationNode.sh

echo "Making GlusterInstallationNode.sh executable..."
ssh -t "$client_user2"@"$client_ip" "sudo chmod +x RaaSI/GlusterInstallationNode.sh"

echo "Executin GlusterInstallationNode.sh on Storage2..."
ssh -t "$client_user2"@"$client_ip" "sudo RaaSI/GlusterInstallationNode.sh"

echo "Setting up GlusterFS on Storage3..."
echo "Enter user to connect to on Storage3: "
read -r client_user3

# validation
val=$(../Validation/checkValidation.sh "$client_user3" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected username"
        echo "Enter user to connect to on Storage3: "
        read -r client_user3
        # validation
        val=$(../Validation/checkValidation.sh "$client_user3" 2)
done

client_ip="$storage3_ip"

echo "Creating RaaSI directory on Storage3 machine..."
ssh "$client_user3"@"$client_ip" "mkdir RaaSI"

echo "Transfering GlusterInstallationNode.sh script to Storage3..."
scp GlusterInstallationNode.sh "$client_user3"@"$client_ip":RaaSI/GlusterInstallationNode.sh

echo "Making GlusterInstallationNode.sh executable..."
ssh -t "$client_user3"@"$client_ip" "sudo chmod +x RaaSI/GlusterInstallationNode.sh"

echo "Executin GlusterInstallationNode.sh on Storage3..."
ssh -t "$client_user3"@"$client_ip" "sudo RaaSI/GlusterInstallationNode.sh"

echo "Adding Storage2 to the gluster cluster..."
ssh -t "$client_user2"@"$client_ip" "sudo gluster peer probe $storage2_ip"

echo "Adding Storage1 to the gluster cluster..."
ssh -t "$client_user1"@"$client_ip" "sudo gluster peer probe $storage1_ip"

echo "Adding GlusterFS volume to Storage1..."
ssh -t "$client_user1"@"$storage1_ip" "sudo apt-mark hold glusterfs* && sudo mkdir -p /data/glusterfs/brick1/gv0"

echo "Adding GlusterFS volume to Storage2..."
ssh -t "$client_user2"@"$storage2_ip" "sudo apt-mark hold glusterfs* && sudo mkdir -p /data/glusterfs/brick1/gv0"

echo "Adding GlusterFS volume to Storage3..."
ssh -t "$client_user3"@"$storage3_ip" "sudo apt-mark hold glusterfs* && sudo mkdir -p /data/glusterfs/brick1/gv0"

echo "Activating GlusterFS volume..."
ssh -t "$client_user1"@"$storage1_ip" "sudo gluster volume create gv0 replica 3 $storage1_ip:/data/glusterfs/brick1/gv0 $storage2_ip:/data/glusterfs/brick1/gv0 $storage3_ip:/data/glusterfs/brick1/gv0 force"

echo "Starting GlusterFS volume..."
ssh -t "$client_user1"@"$storage1_ip" "sudo gluster volume start gv0"
