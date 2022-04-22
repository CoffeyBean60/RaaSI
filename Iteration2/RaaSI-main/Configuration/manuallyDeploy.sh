#!/bin/bash

deployment=$1

mapfile -t node_ip < <(kubectl get nodes -o wide | awk -v x=6 '{if(NR!=1 && $3!="control-plane,plane,master") print $x}')

NODE_CNT="$((${#node_ip[@]}-1))"

echo "Deploying $deployment..."
kubectl scale deployment/"$deployment" --replicas=$NODE_CNT
