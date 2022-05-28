#!/bin/bash

while true
do

	echo "Testing the PSM API dist script..."

	mapfile -t node_ip < <(kubectl get nodes -o wide | awk -v x=6 '{if(NR!=1 && $3=="control-plane,master") print $x}')

	node_count="${#node_ip[@]}"

	service_count=$(grep -c service_type_name all-services.yaml)

	count=1

	for i in "${node_ip[@]}"
	do
		echo "services:" > "$i-services.yaml"
		if [ "$node_count" -ge "$service_count" ]; then
			{
				grep -m"$count" "service_type_name" all-services.yaml | tail -n1
				grep -m"$count" "service_name" all-services.yaml | tail -n1
				grep -m"$count" "service_connection" all-services.yaml | tail -n1
				grep -m"$count" "service_request" all-services.yaml | tail -n1
				echo ""
			} >> "$i-services.yaml"
			count=$(("$count"+1))
			service_count=$(("$service_count"-1))
		elif [ "$service_count" -gt 0 ]; then
			result=$(("$service_count"/"$node_count"))
			for (( j=0; j < "$result"; j++ ))
			do
				{
					grep -m"$count" "service_type_name" all-services.yaml | tail -n1
					grep -m"$count" "service_name" all-services.yaml | tail -n1
					grep -m"$count" "service_connection" all-services.yaml | tail -n1
					grep -m"$count" "service_request" all-services.yaml | tail -n1
					echo ""
				} >> "$i-services.yaml"
				count=$(("$count"+1))
				service_count=$(("$service_count"-1))
			done
		fi;
		grep -A5000 -m1 -e "deployments:" all-services.yaml >> "$i-services.yaml"
		node_count=$(("$node_count"-1))
		result=$(hostname -i | grep "$i")
		if [ -n "$result" ]; then
			cp "$i-services.yaml" "services.yaml"
		fi;
	done
	sleep 2m
done
