#!/bin/bash
# Judge v0.1 - reset.sh
# Author: Ryan Cobb (@cobbr_io)
# Project Home: https://github.com/cobbr/Judge
# License: GNU GPLv3

celery -A judge.tasks purge -f
cd judge || exit
export FLASK_APP=judge.py
flask setup
flask populate
