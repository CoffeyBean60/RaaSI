#!/bin/bash

deployment=$1
NODE_CNT=$2

echo "Deploying $deployment..."
kubectl scale deployment/"$deployment" --replicas="$NODE_CNT"
