#!/bin/bash

deployment=$1

echo "Halting $deployment..."
kubectl scale deployment/"$deployment" --replicas=0
