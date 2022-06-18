#!/bin/bash

echo "Beginning Secondary Master Node Installation..."

echo "Enter the IP of the Master Node that you want to setup: "
read -r master_ip

# validation
val=$(../Validation/checkValidation.sh "$master_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the IP of the Master Node that you want to setup: "
        read -r master_ip
        # validation
        val=$(../Validation/checkValidation.sh "$master_ip" 1)
done

echo "Enter a user with ssh privileges on the Master Node: "
read -r master_user

# validation
val=$(../Validation/checkValidation.sh "$master_user" 2)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected username"
        echo "Enter a user with ssh privileges on the Master Node: "
        read -r master_user
        # validation
        val=$(../Validation/checkValidation.sh "$master_user" 2)
done

echo "Generating join key..."
join_command=$(kubeadm token create --print-join-command)
cert_key=$(kubeadm init phase upload-certs --upload-certs | tail -1)
join_command="$join_command --control-plane --certificate-key $cert_key"
echo "$join_command"

scp -r ../../RaaSI-main "$master_user"@"$master_ip":RaaSI-main
ssh -t "$master_user"@"$master_ip" "sudo chmod +x RaaSI-main/*/*.sh"
ssh -t "$master_user"@"$master_ip" "cd RaaSI-main/MasterNodeSetup || exit; sudo ./secondaryMasterSetup.sh $join_command"

echo "Node added to RaaSI"
