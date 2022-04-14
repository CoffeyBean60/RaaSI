#!/usr/bin/env bats

setup(){
	cd ../../Mock-RaaSI/Mock-MasterSetup || exit
	touch results/secondaryMasterInitMasterIp
	touch results/secondaryMasterInitMasterUser
}
teardown(){
	rm results/secondaryMasterInitMasterIp
        rm results/secondaryMasterInitMasterUser
	cd ../../Tests/MasterSetup || exit
}

@test "master_ip input validation failure blank" {
        ./secondaryMasterInit.sh 
        result=$(cat results/secondaryMasterInitMasterIp)
        [ "$result" == "failed" ]
}

@test "master_ip input validation failure illegal arg" {
        ./secondaryMasterInit.sh "bad Args"                
        result=$(cat results/secondaryMasterInitMasterIp)
        [ "$result" == "failed" ]
}

@test "master_ip input validation success" {
        ./secondaryMasterInit.sh "8.8.8.8"                
        result=$(cat results/secondaryMasterInitMasterIp)
        [ "$result" == "passed" ]
}

@test "master_user input validation failure blank" {
        ./secondaryMasterInit.sh "8.8.8.8"                
        result=$(cat results/secondaryMasterInitMasterUser)
        [ "$result" == "failed" ]
}

@test "master_user input validation failure illegal arg" {
        ./secondaryMasterInit.sh "8.8.8.8" "bad Args"
        result=$(cat results/secondaryMasterInitMasterUser)
        [ "$result" == "failed" ]
}

@test "master_user input validation success" {
        ./secondaryMasterInit.sh "8.8.8.8" "user"     
        result=$(cat results/secondaryMasterInitMasterUser)
        [ "$result" == "passed" ]
}
