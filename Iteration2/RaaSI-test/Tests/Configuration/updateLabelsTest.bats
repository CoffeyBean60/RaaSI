#!/usr/bin/env bats

setup(){
	cd ../../Mock-RaaSI/Mock-Configuration || exit
	rm results/updateLabelsDevice
	rm results/updateLabelsResponse
	rm results/updateLabelsNodeIp
	touch results/updateLabelsDevice
	touch results/updateLabelsResponse
	touch results/updateLabelsNodeIp
}
teardown(){
	touch results/updateLabelsDevice
        touch results/updateLabelsResponse
        touch results/updateLabelsNodeIp 
	cd ../../Tests/Configuration || exit
}

@test "node_ip input validation failure blank" {
        ./updateLabels.sh "1" "2"
        result=$(cat results/updateLabelsNodeIp)
        [ "$result" == "failed" ]
}

@test "node_ip input validation failure illegal arg" {
        ./updateLabels.sh "1" "2" "bad Args"                
        result=$(cat results/updateLabelsNodeIp)
        [ "$result" == "failed" ]
}

@test "node_ip input validation success" {
        ./updateLabels.sh "1" "2" "8.8.8.8"                
        result=$(cat results/updateLabelsNodeIp)
        [ "$result" == "passed" ]
}

@test "response input validation failure blank" {
	./updateLabels.sh
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./updateLabels.sh "1" "bad Argument" "3"
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./updateLabels.sh "1" "Y" "3"
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./updateLabels.sh "1" "y" "3"
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./updateLabels.sh "1" "N" "3"
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./updateLabels.sh "1" "n" "3"
	result=$(cat results/updateLabelsResponse)
	[ "$result" == "passed" ]
}

@test "device input validation failure blank" {
        ./updateLabels.sh                
        result=$(cat results/updateLabelsDevice)
        [ "$result" == "failed" ]
}

@test "device input validation failure illegal argument" {
        ./updateLabels.sh "!good" "2" "3"
        result=$(cat results/updateLabelsDevice)
        [ "$result" == "failed" ]
}

@test "device input validation success" {
        ./updateLabels.sh "good device" "2" "3"          
        result=$(cat results/updateLabelsDevice)
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
