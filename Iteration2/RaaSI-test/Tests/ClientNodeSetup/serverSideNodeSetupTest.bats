#!/usr/bin/env bats

setup(){
	cd ../../Mock-RaaSI/Mock-ClientNodeSetup || exit
	touch results/serverSideNodeSetupClientIp
	touch results/serverSideNodeSetupClientUser
	touch results/serverSideNodeSetupResponse
	touch results/serverSideNodeSetupDevice
}
teardown(){
	rm results/serverSideNodeSetupClientIp
        rm results/serverSideNodeSetupClientUser
        rm results/serverSideNodeSetupResponse
        rm results/serverSideNodeSetupDevice 
	cd ../../Tests/ClientNodeSetup || exit
}

@test "client_ip input validation failure blank" {
        ./serverSideNodeSetup.sh 
        result=$(cat results/serverSideNodeSetupClientIp)
        [ "$result" == "failed" ]
}

@test "client_ip input validation failure illegal arg" {
        ./serverSideNodeSetup.sh "bad Args"                
        result=$(cat results/serverSideNodeSetupClientIp)
        [ "$result" == "failed" ]
}

@test "client_ip input validation success" {
        ./serverSideNodeSetup.sh "8.8.8.8"                
        result=$(cat results/serverSideNodeSetupClientIp)
        [ "$result" == "passed" ]
}

@test "client_user input validation failure blank" {
        ./serverSideNodeSetup.sh                
        result=$(cat results/serverSideNodeSetupClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation failure illegal arg" {
        ./serverSideNodeSetup.sh "1" "bad Args"
        result=$(cat results/serverSideNodeSetupClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation success" {
        ./serverSideNodeSetup.sh "1" "user"     
        result=$(cat results/serverSideNodeSetupClientUser)
        [ "$result" == "passed" ]
}


@test "response input validation failure blank" {
	./serverSideNodeSetup.sh
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./serverSideNodeSetup.sh "1" "2" "bad Argument"
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./serverSideNodeSetup.sh "1" "2" "Y" "4"
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./serverSideNodeSetup.sh "1" "2" "y" "4"
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./serverSideNodeSetup.sh "1" "2" "N" "4"
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./serverSideNodeSetup.sh "1" "2" "n" "4"
	result=$(cat results/serverSideNodeSetupResponse)
	[ "$result" == "passed" ]
}

@test "device discovery not wanted success" {
        ./serverSideNodeSetup.sh "1" "2" "n" "4"                
        result=$(cat results/serverSideNodeSetupDevice)
        [ -z "$result" ]
}

@test "device input validation failure blank" {
        ./serverSideNodeSetup.sh "1" "2" "y"                
        result=$(cat results/serverSideNodeSetupDevice)
        [ "$result" == "failed" ]
}

@test "device input validation failure illegal argument" {
        ./serverSideNodeSetup.sh "1" "2" "y" "!good"
        result=$(cat results/serverSideNodeSetupDevice)
        [ "$result" == "failed" ]
}

@test "device input validation success" {
        ./serverSideNodeSetup.sh "1" "2" "y" "good device"          
        result=$(cat results/serverSideNodeSetupDevice)
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
