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

echo "Have you already completed Kubernetes Installation(Y/N)?"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already completed Kubernetes Installation(Y/N)?"
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

fi

echo "Completed Kubernetes Initial Setup"

echo "Enter the interface that your primary IP is on: "
read -r interface

# validation
val=$(../Validation/checkValidation.sh "$interface" 3)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected interface"
        echo "Enter the interface that your primary IP is on: "
        read -r interface
        # validation
        val=$(../Validation/checkValidation.sh "$interface" 3)
done

masterip=$(ip a s "$interface" | grep -E -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)

echo "Is you ip address " "$masterip" " ? (Y/N)"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Is your ip address $masterip ? (Y/N)"
        read -r response
        # validation
        val=$(../Validation/checkValidation.sh "$response" 0)
done

if [[ "Yy" =~ $response ]]; then echo "Continuing script...";
else
	echo "Error: Unexpected IP; Make sure your IP is set correctly and restart the script"
	exit 1;
fi

echo "Enter the IP address of the Load Balancer: "
read -r LB_ip

# validation
val=$(../Validation/checkValidation.sh "$LB_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the IP address of the Load Balancer: "
        read -r LB_ip
        # validation
        val=$(../Validation/checkValidation.sh "$LB_ip" 1)
done

echo "Enter the port that the Load Balancer uses for the api-server: "
read -r LB_port

# validation
val=$(../Validation/checkValidation.sh "$LB_port" 4)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected port number"
        echo "Enter the port that the Load Balancer uses for the api-server: "
        read -r LB_port
        # validation
        val=$(../Validation/checkValidation.sh "$LB_port" 4)
done

echo "$LB_ip:$LB_port"

echo "Setting up master api-server..."
kubeadm init --control-plane-endpoint "$LB_ip":"$LB_port" --upload-certs --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address="$masterip"

echo "Setting up kubernetes configuration home..."
mkdir -p "$HOME"/.kube
cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

echo "Creating tigera calico overlay network..."
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

echo "Creating dashboard..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

echo "Running proxy for the dashboard in the background..."
kubectl proxy &

echo "Creating default user account for the dashboard..."
kubectl create serviceaccount dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard


echo "The dashboard might take about 8 minutes to initiate"
echo "To check on its status run the command: sudo kubectl get -o wide pods --all-namespaces"
echo "The master server has been set up. Please visit http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ to view the dashboard"
echo "To get the login token please run getDashboardToken.sh"


