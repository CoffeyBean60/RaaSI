#!/bin/bash

echo "Starting BATS Test-Runner..."

echo "Testing ClientNodeSetup"
cd ClientNodeSetup || exit
bats ./*.bats

cd ..
echo "Testing Configuration"
cd Configuration || exit
bats ./*.bats

cd ..
echo "Testing GlusterSetup"
cd GlusterSetup || exit
bats ./*.bats

cd ..
echo "Testing LoadBalancerSetup"
cd LoadBalancerSetup || exit
bats ./*.bats

cd ..
echo "Testing MasterSetup"
cd MasterSetup || exit
bats ./*.bats
