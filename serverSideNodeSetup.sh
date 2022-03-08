#!/bin/bash

master_ip=$(hostname -i)
master_hostname=$(hostname)
join_command=$(kubeadm token create --print-join-command)

echo "Enter ip address to connect: "
read client_ip

echo "Enter username to connect to: "
read client_user

client_hostname=$(ssh $client_user@$client_ip 'hostname')

echo $client_hostname

echo "Adding client to the /etc/hosts file on the master server..."

#sed -i "s/$master_hostname/$master_hostname\\n$client_ip\\t$client_hostname/g" /etc/hosts

echo "Adding the master to the /etc/hosts file on the client server..."

#client_host_command=$(sed -i "s/$client_hostname/$client_hostname\\n$master_ip\\t$master_hostname/g" /etc/hosts)

client_host_command="s/$client_hostname/$client_hostname\\\n$master_ip\\\t$master_hostname/g"
echo $client_host_command

#ssh -t $client_user@$client_ip "sudo sed -i $client_host_command /etc/hosts"

echo "Creating RaaSI directory on client machine..."

#ssh $client_user@$client_ip "mkdir /home/$client_user/RaaSI"

echo "Transfering clientSideNodeSetup.sh script to client machine..."

#scp clientSideNodeSetup.sh $client_user@$client_ip:/home/$client_user/RaaSI/clientSideNodeSetup.sh

echo "Making clientSideNodeSetup.sh executable..."

#ssh -t $client_user@$client_ip "sudo chmod +x /home/$client_user/RaaSI/clientSideNodeSetup.sh"

echo "Executin clientSideNodeSetup.sh on $client_hostname..."

#ssh -t $client_user@$client_ip "sudo /home/$client_user/RaaSI/clientSideNodeSetup.sh"

echo "$client_hostname joining the RaaSI cluster..."

ssh -t $client_user@$client_ip "sudo $join_command"
