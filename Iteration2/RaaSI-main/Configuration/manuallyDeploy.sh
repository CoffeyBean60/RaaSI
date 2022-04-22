#!/bin/bash

deployment=$1
device=$2

mapfile -t node_ip < <(kubectl get nodes -o wide --show-labels | grep "device=$device" | awk -v x=6 '{if($3!="control-plane,plane,master") print $x}')

NODE_CNT="${#node_ip[@]}"

echo "Deploying $deployment..."
kubectl scale deployment/"$deployment" --replicas="$NODE_CNT"
