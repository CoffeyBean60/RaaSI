#!/bin/bash

echo "Beginning script for connect GlusterFS to the RaaSI cluster..."

echo "Have you already completed GlusterFS Installation(Y/N)?"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already completed GlusterFS Installation(Y/N)?"
        read -r response
        # validation
        val=$(../Validation/checkValidation.sh "$response" 0)
done


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
read -r storage1_ip

# validation
val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for the first storage node: "
        read -r storage1_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage1_ip" 1)
done


echo "Enter the ip address for the second storage node: "
read -r storage2_ip

# validation
val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for the second storage node: "
        read -r storage2_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage2_ip" 1)
done


echo "Enter the ip address for the third storage node: "
read -r storage3_ip

# validation
val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for the third storage node: "
        read -r storage3_ip
        # validation
        val=$(../Validation/checkValidation.sh "$storage3_ip" 1)
done


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
  - port: 49152
 -
  addresses:
  - ip: $storage2_ip
  ports:
  - port: 49152
 -
  addresses:
  - ip: $storage3_ip
  ports:
  - port: 49152
EOF

echo "GlusterFS Installation Complete.";

fi

echo "Have you already completed GlusterFS Integration(Y/N)?"
read -r response

# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
        echo "Unexpected Response"
        echo "Have you already completed GlusterFS Integration(Y/N)?"
        read -r response
        # validation
        val=$(../Validation/checkValidation.sh "$response" 0)
done


if [[ "Yy" =~ $response ]]; then
echo "GlusterFS Integration Complete.";
else
echo "Beginning GlusterFS Integration..."

kubectl create -f glusterfs-endpoints.yaml

kubectl create -f glusterfs-service.yaml

kubectl create -f glusterfs-pv.yaml

kubectl create -f glusterfs-pvc.yaml

echo "GlusterFS Integration Complete.";

fi

echo "Connecting GlusterFS to RaaSI cluster complete."
