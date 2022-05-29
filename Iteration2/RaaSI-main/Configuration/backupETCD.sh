#!/bin/bash

echo "Backing up ETCD..."

echo "Would you like to store the backup on a remote machine? (Y/N)"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
	echo "Unexpected Response"
	echo "Would you like to store the backup on a remote machine? (Y/N)"
	read -r response
	val=$(../Validation/checkValidation.sh "$response" 0)
done

if [[ "Yy" =~ $response ]]; then
	echo "Enter the IP address of the remote machine: "
	read -r remote_ip

	# validation
	val=$(../Validation/checkValidation.sh "$remote_ip" 1)
	while [ "passed" != "$val" ];
	do
		echo "Unexpected Response: expected IP address"
		echo "Enter the IP address of the remote machine: "
		read -r remote_ip
		val=$(../Validation/checkValidation.sh "$remote_ip" 1)
	done

	echo "Enter a user to connect to on the remote machine: "
	read -r remote_user

	# validation
	val=$(../Validation/checkValidation.sh "$remote_user" 2)
	while [ "passed" != "$val" ];
	do
		echo "Unexpected Response: expected username"
		echo "Enter a user to connect to on the remote machine: "
		read -r remote_user
		val=$(../Validation/checkValidation.sh "$remote_user" 2)
	done

	echo "Establishing ssh key with remote machine..."

	echo "Creating ssh pub/private key pair on local machine..."
	ssh-keygen -t rsa

	echo "Creating .ssh and backup directories on remote machine..."
	ssh -t "$remote_user"@"$remote_ip" "mkdir .ssh; mkdir backup"

	echo "Sending public key to remote machine..."
	scp /root/.ssh/id_rsa.pub "$remote_user"@"$remote_ip":.ssh/authorized_keys

	echo "Key share complete."
fi;

echo "Installing etcdctl..."
apt-get update
apt-get install etcd-client -y

./doBackup.sh "$response" "$remote_user" "$remote_ip" &
