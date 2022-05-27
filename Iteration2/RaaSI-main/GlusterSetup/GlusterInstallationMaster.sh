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

echo "Setting up TLS on GlusterFS Servers..."
echo "Copying over initial TLS installation to Storage1..."
scp GlusterServerOpenSSL.sh "$client_user1"@"$storage1_ip":RaaSI/GlusterServerOpenSSL.sh

echo "Executing GlusterServerOpenSSL.sh on Storage1..."
ssh -t "$client_user1"@"$storage1_ip" "sudo chmod +x RaaSI/GlusterServerOpenSSL.sh; sudo RaaSI/GlusterServerOpenSSL.sh"

echo "Copying over initial TLS installation to Storage2..."
scp GlusterServerOpenSSL.sh "$client_user2"@"$storage2_ip":RaaSI/GlusterServerOpenSSL.sh

echo "Executing GlusterServerOpenSSL.sh on Storage2..."
ssh -t "$client_user2"@"$storage2_ip" "sudo chmod +x RaaSI/GlusterServerOpenSSL.sh; sudo RaaSI/GlusterServerOpenSSL.sh"

echo "Copying over initial TLS installation to Storage3..."
scp GlusterServerOpenSSL.sh "$client_user3"@"$storage3_ip":RaaSI/GlusterServerOpenSSL.sh

echo "Executing GlusterServerOpenSSL.sh on Storage3..."
ssh -t "$client_user3"@"$storage3_ip" "sudo chmod +x RaaSI/GlusterServerOpenSSL.sh; sudo RaaSI/GlusterServerOpenSSL.sh"

mkdir ca
cd ca || exit
echo "Collecting all certificates from the storage servers..."
scp "$client_user1"@"$storage1_ip":/etc/ssl/glusterfs.pem server1.pem
scp "$client_user2"@"$storage2_ip":/etc/ssl/glusterfs.pem server2.pem
scp "$client_user3"@"$storage3_ip":/etc/ssl/glusterfs.pem server3.pem

echo "Combining certificates into a CA..."
cat server1.pem server2.pem server3.pem > glusterfs.ca

echo "Transefering the glusterfs server CA to all storage servers..."
scp glusterfs.ca "$client_user1"@"$storage1_ip":RaaSI/glusterfs.ca
scp glusterfs.ca "$client_user2"@"$storage2_ip":RaaSI/glusterfs.ca
scp glusterfs.ca "$client_user3"@"$storage3_ip":RaaSI/glusterfs.ca

echo "Transfering the glusterfs client CA to all storage servers..."
scp glusterfs.ca "$client_user1"@"$storage1_ip":RaaSI/glusterfs-client.ca
scp glusterfs.ca "$client_user2"@"$storage2_ip":RaaSI/glusterfs-client.ca
scp glusterfs.ca "$client_user3"@"$storage3_ip":RaaSI/glusterfs-client.ca

echo "Moving the glusterfs.ca and glusterfs-client.ca files to the /etc/ssl directory on all storage servers..."
ssh -t "$client_user1"@"$storage1_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca; sudo mv RaaSI/glusterfs-client.ca /etc/ssl/glusterfs-client.ca"
ssh -t "$client_user2"@"$storage2_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca; sudo mv RaaSI/glusterfs-client.ca /etc/ssl/glusterfs-client.ca"
ssh -t "$client_user3"@"$storage3_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca; sudo mv RaaSI/glusterfs-client.ca /etc/ssl/glusterfs-client.ca"

cd ../
rm -r ca

echo "Getting the hostname for Storage1..."
host1=$(ssh "$client_user1"@"$storage1_ip" "hostname")
echo "$host1"

echo "Getting the hostname for Storage2..."
host2=$(ssh "$client_user2"@"$storage2_ip" "hostname")
echo "$host2"

echo "Getting the hostname for Storage3..."
host3=$(ssh "$client_user3"@"$storage3_ip" "hostname")
echo "$host3"

command1="s/$host1/$host1"'\\n'"$storage2_ip"'\\t'"$host2"'\\n'"$storage3_ip"'\\t'"$host2/g"
command1="sudo sed -i "'"'"$command1"'"'" /etc/hosts"

command2="s/$host2/$host2"'\\n'"$storage1_ip"'\\t'"$host1"'\\n'"$storage3_ip"'\\t'"$host3/g"
command2="sudo sed -i "'"'"$command2"'"'" /etc/hosts"

command3="s/$host3/$host3"'\\n'"$storage1_ip"'\\t'"$host1"'\\n'"$storage2_ip"'\\t'"$host2/g"
command3="sudo sed -i "'"'"$command3"'"'" /etc/hosts"

echo "Adding the servers to /etc/host on Storage1..."
ssh -t "$client_user1"@"$storage1_ip" "$command1"

echo "Adding the servers to /etc/host on Storage2..."
ssh -t "$client_user2"@"$storage2_ip" "$command2"

echo "Adding the servers to /etc/host on Storage3..."
ssh -t "$client_user3"@"$storage3_ip" "$command3"

echo "Adding the servers to the ssl-allow authorization group..."
ssh -t "$client_user1"@"$storage1_ip" "sudo gluster volume set gv0 auth.ssl-allow $host1,$host2,$host3"

echo "Turning on ssl for the volume gv0..."
ssh -t "$client_user1"@"$storage1_ip" "sudo gluster volume set gv0 client.ssl on; sudo gluster volume set gv0 server.ssl on"

echo "Starting GlusterFS volume..."
ssh -t "$client_user1"@"$storage1_ip" "sudo gluster volume start gv0"
