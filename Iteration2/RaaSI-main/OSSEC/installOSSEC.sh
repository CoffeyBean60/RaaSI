#!/bin/bash

curr_dir=$(pwd)

wget -q -O - https://updates.atomicorp.com/installers/atomic | sudo bash

apt update

apt install ossec-hids-server

echo "<directories report_changes='yes' realtime='yes' check_all='yes'>$curr_dir/../../</directories>" >> /var/ossec/etc/ossec.conf

systemctl start ossec
