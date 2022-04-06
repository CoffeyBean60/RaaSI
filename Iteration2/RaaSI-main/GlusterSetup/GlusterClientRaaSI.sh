#!/bin/bash

echo "Beginning script for connect GlusterFS to the RaaSI cluster..."

echo "Have you already completed GlusterFS Installation(Y/N)"
read response
if [[ "Yy" =~ $response ]]; then
echo "GlusterFS Installation Complete.";
else
echo "Beginning GlusterFS Installation..."

apt-get update

apt-get install software-properties-common

add-apt-repository ppa:gluster/glusterfs-7

apt-get update

apt-get install glusterfs-client

echo "Enter the ip address for the first storage node: "
read storage1_ip

echo "Enter the ip address for the second storage node: "
read storage2_ip

echo "Enter the ip address for the third storage node: "
read storage3_ip

#create glusterfs-endpoint.yaml file
# apiVersion: v1
# kind: Endpoints
# metadata:
#  name: glusterfs-cluster
# subsets:
# -
#  addresses:
#  - ip: 192.168.7.244
#  ports:
#  - port: 1729
# -
#  addresses:
#  - ip: 192.168.7.171
#  ports:
#  - port: 1729
# -
#  addresses:
#  - ip: 192.168.7.161
#  ports:
#  - port: 1729

cat <<EOF > glusterfs-endpoints.yaml
apiVersion: v1
kind: Endpoints
metadata:
 name: glusterfs-cluster
subsets:
 -
  addresses:
  - ip: $storage1_ip
  ports:
  - port: 1729
 -
  addresses:
  - ip: $storage2_ip
  ports:
  - port: 1729
 -
  addresses:
  - ip: $storage3_ip
  ports:
  - port: 1729
EOF

echo "GlusterFS Installation Complete.";

fi

echo "Have you already completed GlusterFS Integration(Y/N)"
read response
if [[ "Yy" =~ $response ]]; then
echo "GlusterFS Integration Complete.";
else
echo "Beginning GlusterFS Integration..."

kubectl create -f glusterfs-endpoints.yaml

kubectl create -f glusterfs-pv.yaml

kubectl create -f glusterfs-pvc.yaml

echo "GlusterFS Integration Complete.";

fi

echo "Connecting GlusterFS to RaaSI cluster complete."
