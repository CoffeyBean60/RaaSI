#!/bin/bash
# Judge v0.1 - install.sh
# Author: Ryan Cobb (@cobbr_io)
# Project Home: https://github.com/cobbr/Judge
# License: GNU GPLv3

if [[ "$(pwd)" != *setup ]]
then
    cd ./setup || exit
fi
sudo apt-get install python3-pip rabbitmq-server -y
sudo apt-get install libcurl4-gnutls-dev librtmp-dev -y
sudo pip3 install -r requirements.txt
cd ../judge || exit
export FLASK_APP=judge.py
flask setup
flask populate
