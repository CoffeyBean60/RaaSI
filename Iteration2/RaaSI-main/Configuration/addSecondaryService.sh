#!/bin/bash

echo "Entering Add Secondary Service Script..."

echo "Enter the name of the app that you would like to add: "
read -r app_name

deployment_name="$app_name"-deployment
storage_app_name="$app_name"-storage

echo "Enter the device required for this application: "
read -r device_name

echo "Enter the image name from Docker Hub: "
read -r image_name

echo "Enter the port number required for this image: "
read -r port_num

echo "Enter the minimum amount of memory needed for this service: "
read -r memory_request
memory_request="$memory_request"M

echo "Enter the maximum amount of memory needed for this service: "
read -r memory_limit
memory_limit="$memory_limit"M

echo "Enter the minimum amount of cpu needed for this service: "
read -r cpu_request

echo "Enter the maximum amount of cpu needed for this service: "
read -r cpu_limit

echo "Enter where the glusterfs volume should be mounted on the service: "
read -r mount_path

cat <<EOF > "$deployment_name".yaml
apiVersion: apps/v1
kind: Deployment
metadata:
 name: $deployment_name
 labels:
  app: $app_name
spec:
 replicas: 0
 selector:
  matchLabels:
   app: $app_name
 template:
  metadata:
   labels:
    app: $app_name
  spec:
   affinity:
    nodeAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: device
          operator: In
          values:
          - $device_name
   volumes:
    - name: $storage_app_name
      hostPath:
       path: /gv0
       type: Directory
   containers:
   - image: $image_name
     name: $app_name
     ports:
     - containerPort: $port_num
     resources:
      requests:
       memory: $memory_request
       cpu: $cpu_request
      limits:
       memory: $memory_limit
       cpu: $cpu_limit
     volumeMounts:
      - mountPath: $mount_path
        name: $storage_app_name
EOF
