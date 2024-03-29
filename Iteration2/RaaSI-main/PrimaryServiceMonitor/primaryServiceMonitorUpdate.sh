#!/bin/bash

echo "Entering Update Primary Service Monitor..."

echo "Are you running RaaSI in High Availability Mode? (Y/N)"
read -r response
# validation
val=$(../Validation/checkValidation.sh "$response" 0)
while [ "passed" != "$val" ];
do
	echo "Unexpected Response"
	echo "Are you running RaaSI in High Availability Mode? (Y/N)"
	read -r response
	# validation 
	val=$(../Validation/checkValidation.sh "$response" 0)
done

while [[ "Yy" =~ $response ]];
do
  echo "Enter the ip address for a master node to update the primary service monitoring on:"
  read -r master_ip

  # validation
  val=$(../Validation/checkValidation.sh "$master_ip" 1)
  while [ "passed" != "$val" ];
  do
        echo "Unexpected Response: expected IP address"
        echo "Enter the ip address for a master node to update the primary service monitoring on: "
        read -r master_ip
        # validation
        val=$(../Validation/checkValidation.sh "$master_ip" 1)
  done
  
  echo "Enter user to connect to on the master node: "
  read -r master_user

  # validation
  val=$(../Validation/checkValidation.sh "$master_user" 2)
  while [ "passed" != "$val" ];
  do
        echo "Unexpected Response: expected username"
        echo "Enter user to connect to on the master node: "
        read -r master_user
        # validation
        val=$(../Validation/checkValidation.sh "$master_user" 2)
  done
  
  echo "Copying RaaSI to the master node..."
  scp -r ../../RaaSI-main "$master_user"@"$master_ip":/RaaSI/RaaSI-main
  
  echo "Updating Primary Service API..."
  ssh -t "$master_user"@"$master_ip" "cd /RaaSI/RaaSI-main/PrimaryServiceMonitorAPI/setup && sudo chmod +x reset.sh && sudo ./reset.sh"
  
  echo "Is there another master node to update? (Y/N)"
  read -r response
  # validation
  val=$(../Validation/checkValidation.sh "$response" 0)
  while [ "passed" != "$val" ];
  do
	  echo "Unexpected Response"
	  echo "Is there another master node to update? (Y/N)"
	  read -r response
	  # validation 
	  val=$(../Validation/checkValidation.sh "$response" 0)
  done
done

echo "Updating Primary Service API on local node..."
cd ../PrimaryServiceMonitorAPI/setup || exit
chmod +x install.sh
./reset.sh
