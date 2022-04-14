#!/bin/bash

echo "Beginning script for connect GlusterFS to the RaaSI cluster..."

echo "Have you already completed GlusterFS Installation(Y/N)?"
response=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$response" 0 >> results/GlusterClientRaaSIResponse

echo "Beginning GlusterFS Installation..."

echo "Enter the ip address for the first storage node: "
storage_ip=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$storage_ip" 1 >> results/GlusterClientRaaSIStorageIp

#create glusterfs-endpoint.yaml file
# apiVersion: v1
# kind: Endpoints
# metadata:
#  name: glusterfs-cluster
# subsets:
# -
#  addresses:
#  - ip: 8.8.8.8
#  ports:
#  - port: 1729
# -
#  addresses:
#  - ip: 8.8.8.8
#  ports:
#  - port: 1729
# -
#  addresses:
#  - ip: 8.8.8.8
#  ports:
#  - port: 1729

cat <<EOF > files/glusterfs-endpoints.yaml-mock
apiVersion: v1
kind: Endpoints
metadata:
 name: glusterfs-cluster
subsets:
 -
  addresses:
  - ip: $storage_ip
  ports:
  - port: 1729
 -
  addresses:
  - ip: $storage_ip
  ports:
  - port: 1729
 -
  addresses:
  - ip: $storage_ip
  ports:
  - port: 1729
EOF

echo "GlusterFS Installation Complete.";

echo "Connecting GlusterFS to RaaSI cluster complete."
