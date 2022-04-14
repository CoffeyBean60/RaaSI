#!/usr/bin/env bats

setup(){
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/fstab-mock ../../Mock-RaaSI/Mock-MasterSetup/files/fstab-mock
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/kubernetes.list-mock ../../Mock-RaaSI/Mock-MasterSetup/files/kubernetes.list-mock
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/10-kubeadm.conf-mock ../../Mock-RaaSI/Mock-MasterSetup/files/10-kubeadm.conf-mock
	cd ../../Mock-RaaSI/Mock-MasterSetup || exit
	touch results/masterSetupResponse
	touch results/masterSetupInterface
	touch results/masterSetupLBIp
	touch results/masterSetupLBPort
}
teardown(){
	rm results/masterSetupResponse
	rm results/masterSetupInterface
	rm results/masterSetupLBIp
	rm results/masterSetupLBPort
	cd ../../Tests/MasterSetup || exit
}

@test "fstab modification" {
	./masterSetup.sh
	expected="files/correct-files/fstab-mock"
	actual="files/fstab-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "kubernetes.list modification" {
	./masterSetup.sh
	expected="files/correct-files/kubernetes.list-mock"
	actual="files/kubernetes.list-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "10-kubeadm.conf-mock modification" {
	./masterSetup.sh
	expected="files/correct-files/10-kubeadm.conf-mock"
	actual="files/10-kubeadm.conf-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "response input validation failure blank" {
	./masterSetup.sh
	result=$(cat results/masterSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./masterSetup.sh "bad Argument"
	result=$(cat results/masterSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./masterSetup.sh "Y"
	result=$(cat results/masterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./masterSetup.sh "y"
	result=$(cat results/masterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./masterSetup.sh "N"
	result=$(cat results/masterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./masterSetup.sh "n"
	result=$(cat results/masterSetupResponse)
	[ "$result" == "passed" ]
}

@test "interface input validation failure blank" {
	./masterSetup.sh "y"
	result=$(cat results/masterSetupInterface)
	[ "$result" == "failed" ]
}

@test "interface input validation failure illegal argument" {
        ./masterSetup.sh "y" "!Good"
        result=$(cat results/masterSetupInterface)
        [ "$result" == "failed" ]
}

@test "interface input validation success" {
        ./masterSetup.sh "y" "eth"
        result=$(cat results/masterSetupInterface)
        [ "$result" == "passed" ]
}

@test "LB_ip input validation failure blank" {
        ./masterSetup.sh "y" "eth"
        result=$(cat results/masterSetupLBIp)
        [ "$result" == "failed" ]
}

@test "LB_ip input validation failure illegal argument" {
        ./masterSetup.sh "y" "eth" "Bad Args"
        result=$(cat results/masterSetupLBIp)
        [ "$result" == "failed" ]
}

@test "LB_ip input validation success" {
        ./masterSetup.sh "y" "eth" "8.8.8.8"
        result=$(cat results/masterSetupLBIp)
        [ "$result" == "passed" ]
}

@test "LB_port input validation failure blank" {
        ./masterSetup.sh "y" "eth" "8.8.8.8"
        result=$(cat results/masterSetupLBPort)
        [ "$result" == "failed" ]
}

@test "LB_port input validation failure illegal argument" {
        ./masterSetup.sh "y" "eth" "8.8.8.8" "Bad Args"
        result=$(cat results/masterSetupLBPort)
        [ "$result" == "failed" ]
}

@test "LB_port input validation success" {
        ./masterSetup.sh "y" "eth" "8.8.8.8" "123"
        result=$(cat results/masterSetupLBPort)
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
