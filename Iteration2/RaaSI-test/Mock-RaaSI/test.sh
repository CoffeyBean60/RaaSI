#!/bin/bash

expected="$1"
actual="$2"

compare=$(diff --brief "$expected" "$actual")
if [ -z "$compare" ]; then
	echo "good";
else
	echo "bad";
fi
