#!/bin/bash

echo "Beginning script for connect GlusterFS to the RaaSI cluster..."

apt-get install gluster-client

#create glusterfs-endpoint.yaml file
#TODO: how to generate this???
# apiVersion: v1
# kind: Endpoints
# metadata:
#  name: glusterfs-cluster
# subsets:
# - addresses:
#  - ip: 192.168.7.244
#  ports:
#  - port: 1729
# - addresses:
#  - ip: 192.168.7.171
#  ports:
#  - port: 1729
# - addresses:
#  - ip: 192.168.7.161
#  ports:
#  - port: 1729

# kubectl create -f glusterfs-endpoints.yaml

# kubectl create -f glusterfs-pv.yaml

# kubectl create -f glusterfs-pvc.yaml
