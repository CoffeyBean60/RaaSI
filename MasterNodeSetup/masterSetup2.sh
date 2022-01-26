#!/bin/bash

echo "Beginning masterSetup2.sh"

masterip=$(hostname -i)

echo "Is you ip address " $masterip " ? (Y/N)"
read response

if [[ "Yy" =~ "$response" ]]; then echo "Continuing script...";
else
	echo "Error: Unexpected IP; Make sure your IP is set correctly and restart the script"
	exit 1;
fi

echo "Setting up master api-server..."
kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$masterip

echo "Setting up kubernetes configuration home..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

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

echo "The master server has been set up. Please visit http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/ to view the dashboard"
echo "To get the login token please run getDashboardToken.sh"
