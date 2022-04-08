#!/bin/bash

echo "Getting the dashboard token..."

kubectl get secret "$(kubectl get serviceaccount dashboard -o jsonpath='{.secrets[0].name}')" -o jsonpath="{.data.token}" | base64 --decode

