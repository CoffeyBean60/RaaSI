#!/usr/bin/env bats

setup(){
	cd ../../Mock-RaaSI/Mock-GlusterSetup || exit
	touch results/GlusterInstallationMasterStorageIp
	touch results/GlusterInstallationMasterClientUser
}
teardown(){
	rm results/GlusterInstallationMasterStorageIp
        rm results/GlusterInstallationMasterClientUser 
	cd ../../Tests/GlusterSetup || exit
}

@test "storage_ip input validation failure blank" {
        ./GlusterInstallationMaster.sh 
        result=$(cat results/GlusterInstallationMasterStorageIp)
        [ "$result" == "failed" ]
}

@test "storage_ip input validation failure illegal arg" {
        ./GlusterInstallationMaster.sh "bad Args"                
        result=$(cat results/GlusterInstallationMasterStorageIp)
        [ "$result" == "failed" ]
}

@test "storage_ip input validation success" {
        ./GlusterInstallationMaster.sh "8.8.8.8"                
        result=$(cat results/GlusterInstallationMasterStorageIp)
        [ "$result" == "passed" ]
}

@test "client_user input validation failure blank" {
        ./GlusterInstallationMaster.sh "8.8.8.8"               
        result=$(cat results/GlusterInstallationMasterClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation failure illegal arg" {
        ./GlusterInstallationMaster.sh "1" "bad Args"
        result=$(cat results/GlusterInstallationMasterClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation success" {
        ./GlusterInstallationMaster.sh "1" "user"     
        result=$(cat results/GlusterInstallationMasterClientUser)
        [ "$result" == "passed" ]
}


#@test "addition using bc" {
#        result="$(echo 2+2 | bc)"
#        [ "$result" -eq 4 ]
#}

#@test "addition using dc" {
#        result="$(echo 2 2+p | dc)"
#        [ "$result" -eq 4 ]
#}
