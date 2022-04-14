#!/bin/bash

response=$1
# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/clientSideNodeSetupResults

echo "Beginning Initial System Configuration"
echo "Initial update of system"

echo "Turning off swap"

sed -i 's/\/swapfile/#\/swapfile/g' files/fstab-mock

echo "Initial System Configuration Complete.";

echo "Beginning Kubernetes Installation"
cat <<EOF > files/kubernetes.list-mock
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "Kubernetes Installation Complete.";

echo "Beginning Kubernetes Configuration"
word1="EnvironmentFile=-\/etc\/default\/kubelet"
word2='Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"'
sed -i "s/$word1/$word1\\n$word2/g" files/10-kubeadm.conf-mock

word3="ExecStart=\/usr\/bin\/kubelet"
word4="ExecStart=\/usr\/bin\/kubelet \$KUBELET_CGROUP_ARGS"
sed -i "s/$word3/$word4/g" files/10-kubeadm.conf-mock

echo "Kubernetes Configuration Complete."

echo "Configuration complete please join the cluster now."
