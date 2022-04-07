#!/bin/bash

deployment=$1

echo "Deploying $deployment..."
kubectl scale deployment/"$deployment" --replicas=100
