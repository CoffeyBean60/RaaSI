#!/bin/bash

echo "Have you already completed the Initial System Configuration? (Y/N)"
read response
if [[ "Yy" =~ "$response" ]]; then
	echo "Initial System Configuraton Completed.";
else
echo "Beginning Initial System Configuration"
echo "Initial update of system"
apt-get update

echo "Turning off swap"
swapoff -a

sed -i 's/\/swapfile/#\/swapfile/g' /etc/fstab

echo "Modifying /etc/hosts to add master machine"
echo "Please run nodeSetup1.sh on the master server"
echo "Your IP address is " $(hostname -i)
echo "Your hostname is " $(hostname)
masterresponse=$(nc -w 10 -l 3333)

arrIN=(${masterresponse//;/ })

masterIP=${arrIN[0]}
echo "Found master IP at: "$masterIP

masterHostname=${arrIN[1]}
echo "Found master Hostname at: "$masterHostname

echo "Is this IP and hostname expected?(Y/N)"
read response

if [[ "Yy" =~ "$response" ]]; then echo "yes";
 else 
	echo "Incorrect IP or Hostname found. Please restart this script."
	exit 1;
fi

myhostname=$(hostname)

sed -i "s/$myhostname/$myhostname\\n$masterIP\\t$masterHostname/g" /etc/hosts
echo "Initial System Configuration Complete.";
fi

echo "Have you already completed Kubernetes Installation(Y/N)"
read response
if [[ "Yy" =~ "$response" ]]; then
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
read response
if [[ "Yy" =~ "$response" ]]; then
echo "Kubernetes Configuration Complete.";
else
echo "Beginning Kubernetes Configuration"
word1="EnvironmentFile=-\/etc\/default\/kubelet"
echo $word1
word2='Environment=\"KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs\"'
echo $word2
sed -i "s/$word1/$word1\\n$word2/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

word3="ExecStart=\/usr\/bin\/kubelet"
word4="ExecStart=\/usr\/bin\/kubelet \$KUBELET_CGROUP_ARGS"
sed -i "s/$word3/$word4/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "Kubernetes Configuration Complete.";
fi

echo "Please reboot your system and run the localnodesetup2.sh script"
