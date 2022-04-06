#!/bin/bash

echo "Beginning Load Balancer setup script..."

echo "Enter the ip address for LoadBalancer1: "
read LB1_ip

echo "Enter the ip address for LoadBalancer2: "
read LB2_ip

echo "Enter the ip address for LoadBalancer3: "
read LB3_ip

echo "IP addresses for each kubernetes master node are required."
echo "Enter the ip address for Master1: "
read M1_ip

echo "Enter the ip address for Master2: "
read M2_ip

echo "Enter the ip address for Master3: "
read M3_ip

echo "For keepalived configuration, the following is needed."
echo "Enter the interface name used on the Load Balancers: "
read interface

echo "Enter the virtual IP that you want the Load Balancers to use: "
read vip

echo "Cloning keepalived.conf.primary to keepalived.conf.primary.mod..."
cp keepalived.conf.primary keepalived.conf.primary.mod

echo "Modifying keepalived.conf.primary.mod..."
word1='${INTERFACE}'
sed -i "s/$word1/$interface/g" keepalived.conf.primary.mod

word1='${APISERVER_VIP}'
sed -i "s/$word1/$vip/g" keepalived.conf.primary.mod

echo "Cloning check_apiserver.sh.all to check_apiserver.sh.all.mod..."
cp check_apiserver.sh.all check_apiserver.sh.all.mod

echo "Modifying check_apiserver.sh.all.mod..."
sed -i "s/$word1/$vip/g" check_apiserver.sh.all.mod

echo "Cloning keepalived.conf.secondary to keepalived.conf.secondary.mod..."
cp keepalived.conf.secondary keepalived.conf.secondary.mod

echo "Modifying keepalived.conf.secondary.mod..."
word1='${INTERFACE}'
sed -i "s/$word1/$interface/g" keepalived.conf.secondary.mod
word1='${APISERVER_VIP}'
sed -i "s/$word1/$vip/g" keepalived.conf.secondary.mod

echo "Cloning haproxy.cfg.all to haproxy.cfg.all.mod..."
cp haproxy.cfg.all haproxy.cfg.all.mod

echo "Modifying haproxy.cfg.all.mod..."
word1='${HOST1_ADDRESS}'
sed -i "s/$word1/$M1_ip/g" haproxy.cfg.all.mod
word1='${HOST2_ADDRESS}'
sed -i "s/$word1/$M2_ip/g" haproxy.cfg.all.mod
word1='${HOST3_ADDRESS}'
sed -i "s/$word1/$M3_ip/g" haproxy.cfg.all.mod



echo "Setting up Load Balancer on LoadBalancer1..."
echo "Enter user to connect to on LoadBalancer1: "
read client_user1

ssh -t $client_user1@$LB1_ip "sudo apt-get update; sudo apt-get install -y haproxy; sudo apt-get install -y keepalived; mkdir tmp"
scp keepalived.conf.primary.mod $client_user1@$LB1_ip:tmp/keepalived.conf
scp check_apiserver.sh.all.mod $client_user1@$LB1_ip:tmp/check_apiserver.sh
scp haproxy.cfg.all.mod $client_user1@$LB1_ip:tmp/haproxy.cfg
ssh -t $client_user1@$LB1_ip "sudo mv tmp/keepalived.conf /etc/keepalived/keepalived.conf; sudo mv tmp/check_apiserver.sh /etc/keepalived/check_apiserver.sh; sudo mv tmp/haproxy.cfg /etc/haproxy/haproxy.cfg"

echo "Setting up Load Balancer on LoadBalancer2..."
echo "Enter user to connect to on LoadBalancer2: "
read client_user2

ssh -t $client_user2@$LB2_ip "sudo apt-get update; sudo apt-get install -y haproxy; sudo apt-get install -y keepalived; mkdir tmp"
scp keepalived.conf.secondary.mod $client_user2@$LB2_ip:tmp/keepalived.conf
scp check_apiserver.sh.all.mod $client_user2@$LB2_ip:tmp/check_apiserver.sh
scp haproxy.cfg.all.mod $client_user2@$LB2_ip:tmp/haproxy.cfg
ssh -t $client_user2@$LB2_ip "sudo mv tmp/keepalived.conf /etc/keepalived/keepalived.conf; sudo mv tmp/check_apiserver.sh /etc/keepalived/check_apiserver.sh; sudo mv tmp/haproxy.cfg /etc/haproxy/haproxy.cfg"

echo "Setting up Load Balancer on LoadBalancer3..."
echo "Enter user to connect to on LoadBalancer3: "
read client_user3

ssh -t $client_user3@$LB3_ip "sudo apt-get update; sudo apt-get install -y haproxy; sudo apt-get install -y keepalived; mkdir tmp"
scp keepalived.conf.secondary.mod $client_user3@$LB3_ip:tmp/keepalived.conf
scp check_apiserver.sh.all.mod $client_user3@$LB3_ip:tmp/check_apiserver.sh
scp haproxy.cfg.all.mod $client_user3@$LB3_ip:tmp/haproxy.cfg
ssh -t $client_user3@$LB3_ip "sudo mv tmp/keepalived.conf /etc/keepalived/keepalived.conf; sudo mv tmp/check_apiserver.sh /etc/keepalived/check_apiserver.sh; sudo mv tmp/haproxy.cfg /etc/haproxy/haproxy.cfg"

echo "Starting Load Balancer services on LoadBalancer1..."
ssh -t $client_user1@$LB1_ip "sudo systemctl enable haproxy --now; sudo systemctl enable keepalived --now; sudo systemctl restart haproxy; sudo systemctl restart keepalived"

echo "Starting Load Balancer services on LoadBalancer2..."
ssh -t $client_user2@$LB2_ip "sudo systemctl enable haproxy --now; sudo systemctl enable keepalived --now; sudo systemctl restart haproxy; sudo systemctl restart keepalived"

echo "Starting Load Balancer services on LoadBalancer3..."
ssh -t $client_user3@$LB3_ip "sudo systemctl enable haproxy --now; sudo systemctl enable keepalived --now; sudo systemctl restart haproxy; sudo systemctl restart keepalived"

echo "Load Balancers have been setup succefully!"
