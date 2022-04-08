#!/bin/bash

string=$1
type=$2

if [ "0" == "$type" ]; then
	# validate if string is in the form of yY or nN
	# regex: [yYnN]
	[[ "$string" =~ ^[yYnN]$ ]] && echo "passed" || echo "failed"
elif [ "1" == "$type" ]; then
	# validate if string is in the form of an ip address
	# regex: ^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$
	[[ "$string" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] && echo "passed" || echo "failed"
elif [ "2" == "$type" ]; then
	# validate if string is in the form of a linux username
	# regex: ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$
	[[ "$string" =~ ^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]] && echo "passed" || echo "failed"
elif [ "3" == "$type" ]; then
	# validate if string has no special characters
	# regex: [A-Za-z0-9 ]
	[[ "$string" =~ ^([A-Za-z0-9 ]+)$ ]] && echo "passed" || echo "failed"
else
	echo "Not good type";
fi

