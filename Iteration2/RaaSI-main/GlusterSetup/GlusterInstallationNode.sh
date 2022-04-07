#!/bin/bash

echo "Starting GlusterFS Installation Script..."

apt-get update

apt-get install -y wget

wget -O -https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add -

echo "deb [arch=amd64] https://download.gluster.org/pub/gluster/glusterfs/7/LATEST/Debian/buster/amd64/apt buster main" > /etc/apt/sources.list.d/gluster.list

apt-get update
apt-get install -y glusterfs-server

systemctl start glusterd
systemctl enable glusterd
