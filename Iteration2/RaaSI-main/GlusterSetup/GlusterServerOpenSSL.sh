#!/bin/bash

echo "Generating openssl key and certificate on GlusterFS server..."
host=$(hostname)

# Generate private key
echo "Generating Private Key..."
sudo openssl genrsa -out /etc/ssl/glusterfs.key 2048

# Generate a signed certificate
echo "Generating a signed certificate..."
sudo openssl req -new -x509 -key /etc/ssl/glusterfs.key -subj "/CN=$host" -out /etc/ssl/glusterfs.pem

