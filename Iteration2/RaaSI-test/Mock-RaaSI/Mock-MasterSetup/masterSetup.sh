#!/bin/bash

echo "Have you already completed the Initial System Configuration? (Y/N)"
response=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/masterSetupResponse

sed -i 's/\/swapfile/#\/swapfile/g' files/fstab-mock

echo "Initial System Configuration Complete.";

cat <<EOF > files/kubernetes.list-mock
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Beginning Kubernetes Configuration"
word1="EnvironmentFile=-\/etc\/default\/kubelet"
word2='Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"'
sed -i "s/$word1/$word1\\n$word2/g" files/10-kubeadm.conf-mock

word3="ExecStart=\/usr\/bin\/kubelet"
word4="ExecStart=\/usr\/bin\/kubelet \$KUBELET_CGROUP_ARGS"
sed -i "s/$word3/$word4/g" files/10-kubeadm.conf-mock

echo "Completed Kubernetes Initial Setup"

echo "Enter the interface that your primary IP is on: "
interface=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$interface" 3 >> results/masterSetupInterface

echo "Enter the IP address of the Load Balancer: "
LB_ip=$3

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$LB_ip" 1 >> results/masterSetupLBIp

echo "Enter the port that the Load Balancer uses for the api-server: "
LB_port=$4

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$LB_port" 4 >> results/masterSetupLBPort

echo "The dashboard might take about 8 minutes to initiate"
echo "To check on its status run the command: sudo kubectl get -o wide pods --all-namespaces"
echo "The master server has been set up. Please visit http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ to view the dashboard"
echo "To get the login token please run getDashboardToken.sh"


