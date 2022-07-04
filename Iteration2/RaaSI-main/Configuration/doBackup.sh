#!/bin/bash

remote_user=$1
remote_ip=$2

while true
do
	echo "Creating backup of etcd..."
	ETCDCTL_API=3 etcdctl snapshot save etcdBackup.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key

        scp etcdBackup.db "$remote_user"@"$remote_ip":backup/etcdBackup.db

        sleep 30m

done
