#!/bin/bash

response=$1
remote_user=$2
remote_ip=$3

while true
do
	echo "Creating backup of etcd..."
	ETCDCTL_API=3 etcdctl snapshot save etcdBackup.db --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key

	if [[ "Yy" =~ $response ]]; then
                scp etcdBackup.db "$remote_user"@"$remote_ip":backup/etcdBackup.db
        fi;

        sleep 30m

done
