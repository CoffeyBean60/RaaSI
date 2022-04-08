#!/bin/bash

echo "Have you already completed the Initial System Configuration? (Y/N)"
read -r response
# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
	echo "Unexpected Response"
	echo "Have you already completed the Initial System Configuration? (Y/N)"
	read -r response
	# validation 
	val=$(../Validation/checkValidation.sh "$response" 0)
done

if [[ "Yy" =~ $response ]]; then
	echo "Initial System Configuraton Completed.";
else
echo "Beginning Initial System Configuration"
echo "Initial update of system"
apt-get update

echo "Turning off swap"
swapoff -a

sed -i 's/\/swapfile/#\/swapfile/g' /etc/fstab

echo "Initial System Configuration Complete.";
fi

echo "Have you already completed Kubernetes Installation(Y/N)"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already completed Kubernetes Installation(Y/N)"
        read -r response
        # validation 
        val=$(../Validation/checkValidation.sh "$response" 0)
done


if [[ "Yy" =~ $response ]]; then
echo "Kubernetes Installation Complete.";
else
echo "Beginning Kubernetes Installation"
apt-get install -y openssh-server
apt-get install -y docker.io
apt-get install apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update

apt-get install -y kubelet kubeadm kubectl

echo "Kubernetes Installation Complete.";
fi

echo "Have you already completed Kubernetes Configuration?(Y/N)"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already completed Kubernetes Configuration?(Y/N)"
        read -r response
        # validation 
        val=$(../Validation/checkValidation.sh "$response" 0)
done


if [[ "Yy" =~ $response ]]; then
echo "Kubernetes Configuration Complete.";
else
echo "Beginning Kubernetes Configuration"
word1="EnvironmentFile=-\/etc\/default\/kubelet"
word2='Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"'
sed -i "s/$word1/$word1\\n$word2/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

word3="ExecStart=\/usr\/bin\/kubelet"
word4="ExecStart=\/usr\/bin\/kubelet \$KUBELET_CGROUP_ARGS"
sed -i "s/$word3/$word4/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "Kubernetes Configuration Complete."
fi

echo "Configuration complete please join the cluster now."
