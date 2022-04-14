#!/usr/bin/env bats

setup(){
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/fstab-mock ../../Mock-RaaSI/Mock-MasterSetup/files/fstab-mock
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/kubernetes.list-mock ../../Mock-RaaSI/Mock-MasterSetup/files/kubernetes.list-mock
	cp ../../Mock-RaaSI/Mock-MasterSetup/files/copy-files/10-kubeadm.conf-mock ../../Mock-RaaSI/Mock-MasterSetup/files/10-kubeadm.conf-mock
	cd ../../Mock-RaaSI/Mock-MasterSetup || exit
	touch results/secondaryMasterSetupResponse
}
teardown(){
	rm results/secondaryMasterSetupResponse
	cd ../../Tests/MasterSetup || exit
}

@test "fstab modification" {
	./secondaryMasterSetup.sh
	expected="files/correct-files/fstab-mock"
	actual="files/fstab-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "kubernetes.list modification" {
	./secondaryMasterSetup.sh
	expected="files/correct-files/kubernetes.list-mock"
	actual="files/kubernetes.list-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "10-kubeadm.conf-mock modification" {
	./secondaryMasterSetup.sh
	expected="files/correct-files/10-kubeadm.conf-mock"
	actual="files/10-kubeadm.conf-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "response input validation failure blank" {
	./secondaryMasterSetup.sh
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./secondaryMasterSetup.sh "bad Argument"
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./secondaryMasterSetup.sh "Y"
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./secondaryMasterSetup.sh "y"
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./secondaryMasterSetup.sh "N"
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./secondaryMasterSetup.sh "n"
	result=$(cat results/secondaryMasterSetupResponse)
	[ "$result" == "passed" ]
}


