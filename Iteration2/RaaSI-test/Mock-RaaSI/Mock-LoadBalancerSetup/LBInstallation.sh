#!/bin/bash

echo "Beginning Load Balancer setup script..."

echo "Enter the ip address for LoadBalancer1: "
LB_ip=$1

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$LB_ip" 1 >> results/LBInstallationLBIp

echo "For keepalived configuration, the following is needed."
echo "Enter the interface name used on the Load Balancers: "
interface=$2

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$interface" 3 >> results/LBInstallationInterface

echo "Modifying keepalived.conf.primary.mod..."
word1='INTERFACE'
sed -i "s/$word1/$interface/g" files/keepalived.conf.primary-mock

word1='APISERVER_VIP'
sed -i "s/$word1/$LB_ip/g" files/keepalived.conf.primary-mock

echo "Modifying check_apiserver.sh.all.mod..."
sed -i "s/$word1/$LB_ip/g" files/check_apiserver.sh.all-mock

echo "Modifying keepalived.conf.secondary.mod..."
word1='INTERFACE'
sed -i "s/$word1/$interface/g" files/keepalived.conf.secondary-mock
word1='APISERVER_VIP'
sed -i "s/$word1/$LB_ip/g" files/keepalived.conf.secondary-mock

echo "Modifying haproxy.cfg.all.mod..."
word1='HOST1_ADDRESS'
sed -i "s/$word1/$LB_ip/g" files/haproxy.cfg.all-mock
word1='HOST2_ADDRESS'
sed -i "s/$word1/$LB_ip/g" files/haproxy.cfg.all-mock
word1='HOST3_ADDRESS'
sed -i "s/$word1/$LB_ip/g" files/haproxy.cfg.all-mock



echo "Setting up Load Balancer on LoadBalancer1..."
echo "Enter user to connect to on LoadBalancer1: "
client_user=$3

# validation
../../../RaaSI-main/Validation/checkValidation.sh "$client_user" 2 >> results/LBInstallationClientUser

echo "Load Balancers have been setup succefully!"
