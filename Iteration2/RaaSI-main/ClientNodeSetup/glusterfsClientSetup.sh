#!/bin/bash

client_ip=$1
client_user=$2

echo "Connecting the client node to GlusterFS..."

echo "Enter the IP address for Storage1:"
read -r storage1_ip

# validation
val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the IP address for Storage1: "
        read -r storage1_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
done

echo "Enter username to connect to on Storage1: "
read -r storage_user1

# validation
val=$(../Validation/checkValidation.sh "$storage_user1" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: valid username was expected"
        echo "Enter username to connect to on Storage1: "
        read -r storage_user1
        # validation
        val=$(../Validation/checkValidation.sh "$storage_user1" 2)
done

echo "Enter the IP address for Storage2:"
read -r storage2_ip

# validation
val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the IP address for Storage2: "
        read -r storage2_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
done

echo "Enter username to connect to on Storage2: "
read -r storage_user2

# validation
val=$(../Validation/checkValidation.sh "$storage_user2" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: valid username was expected"
        echo "Enter username to connect to on Storage2: "
        read -r storage_user2
        # validation
        val=$(../Validation/checkValidation.sh "$storage_user2" 2)
done

echo "Enter the IP address for Storage3:"
read -r storage3_ip

# validation
val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the IP address for Storage3: "
        read -r storage3_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
done

echo "Enter username to connect to on Storage3: "
read -r storage_user3

# validation
val=$(../Validation/checkValidation.sh "$storage_user3" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: valid username was expected"
        echo "Enter username to connect to on Storage3: "
        read -r storage_user3
        # validation
        val=$(../Validation/checkValidation.sh "$storage_user3" 2)
done

echo "Copying over initial TLS installation to client..."
scp ../GlusterSetup/GlusterServerOpenSSL.sh "$client_user"@"$client_ip":RaaSI/GlusterServerOpenSSL.sh

echo "Executing GlusterServerOpenSSL.sh on client..."
ssh -t "$client_user"@"$client_ip" "sudo chmod +x RaaSI/GlusterServerOpenSSL.sh; sudo RaaSI/GlusterServerOpenSSL.sh"

mkdir ca
cd ca || exit
echo "Collecting client CA from the storage server..."
scp "$storage_user1"@"$storage1_ip":/etc/ssl/glusterfs.ca glusterfs-client.ca

echo "Transfering glusterfs.ca to the client..."
scp glusterfs-client.ca "$client_user"@"$client_ip":RaaSI/glusterfs.ca

echo "Moving glusterfs.ca to /etc/ssl/glusterfs.ca on client..."
ssh -t "$client_user"@"$client_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca"

echo "Collection server CA from the storage server..."
scp "$storage_user1"@"$storage1_ip":/etc/ssl/glusterfs.ca glusterfs.ca

echo "Collecting the certificate from client..."
scp "$client_user"@"$client_ip":/etc/ssl/glusterfs.pem client.pem

echo "Appending the client certificate to the server CA..."
cat client.pem >> glusterfs.ca

echo "Sending new CA to all servers..."
scp glusterfs.ca "$storage_user1"@"$storage1_ip":RaaSI/glusterfs.ca
scp glusterfs.ca "$storage_user2"@"$storage2_ip":RaaSI/glusterfs.ca
scp glusterfs.ca "$storage_user3"@"$storage3_ip":RaaSI/glusterfs.ca

echo "Moving glusterfs.ca to /etc/ssl/glusterfs.ca on all servers..."
ssh -t "$storage_user1"@"$storage1_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca"
ssh -t "$storage_user2"@"$storage2_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca"
ssh -t "$storage_user3"@"$storage3_ip" "sudo mv RaaSI/glusterfs.ca /etc/ssl/glusterfs.ca"

echo "Getting the hostname of the client..."
host=$(ssh "$client_user"@"$client_ip" "hostname")
echo "$host"

echo "Getting the hostnames of the storage servers..."
hostS1=$(ssh "$storage_user1"@"$storage1_ip" "hostname")
echo "$hostS1"
hostS2=$(ssh "$storage_user2"@"$storage2_ip" "hostname")
echo "$hostS2"
hostS3=$(ssh "$storage_user3"@"$storage3_ip" "hostname")
echo "$hostS3"

command1="s/$hostS1/$hostS1"'\\n'"$client_ip"'\\t'"$host/g"
command1="sudo sed -i "'"'"$command1"'"'" /etc/hosts"

command2="s/$hostS2/$hostS2"'\\n'"$client_ip"'\\t'"$host/g"
command2="sudo sed -i "'"'"$command2"'"'" /etc/hosts"

command3="s/$hostS3/$hostS3"'\\n'"$client_ip"'\\t'"$host/g"
command3="sudo sed -i "'"'"$command3"'"'" /etc/hosts"

echo "Adding the client to /etc/host on Storage1..."
ssh -t "$storage_user1"@"$storage1_ip" "$command1"

echo "Adding the client to /etc/host on Storage2..."
ssh -t "$storage_user2"@"$storage2_ip" "$command2"

echo "Adding the client to /etc/host on Storage3..."
ssh -t "$storage_user3"@"$storage3_ip" "$command3"

echo "Getting the authorization set from GlusterFS..."
echo "Please type the password twice"
slist=$(ssh -t "$storage_user1"@"$storage1_ip" "sudo gluster volume get gv0 auth.ssl-allow")


slist=$(echo "$slist" | awk -v x=2 '{if(NR!=1 && NR!=2 && NR!=3) print $x}')

slist="$host,$slist"

echo "Adding the client to the ssl-allow authorization group..."
ssh -t "$storage_user1"@"$storage1_ip" "sudo gluster volume set gv0 auth.ssl-allow $slist"

echo "Restarting the Glusterfs volume gv0..."
ssh -t "$storage_user1"@"$storage1_ip" "sudo gluster volume stop gv0; sudo gluster volume start gv0"

echo "Mounting the GlusterFS volume to client machine..."
ssh -t "$client_user"@"$client_ip" "sudo mkdir /gv0 && sudo mount -t glusterfs $storage1_ip:/gv0 /gv0"

rm -rf ca

