#!/bin/bash

echo "Have you already completed the Initial System Configuration? (Y/N)"
response=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/secondaryMasterSetupResponse

sed -i 's/\/swapfile/#\/swapfile/g' files/fstab-mock

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

