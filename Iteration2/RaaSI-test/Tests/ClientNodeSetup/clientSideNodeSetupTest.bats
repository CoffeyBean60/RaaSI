#!/usr/bin/env bats

setup(){
	cp ../../Mock-RaaSI/Mock-ClientNodeSetup/files/copy-files/fstab-mock ../../Mock-RaaSI/Mock-ClientNodeSetup/files/fstab-mock
	cp ../../Mock-RaaSI/Mock-ClientNodeSetup/files/copy-files/kubernetes.list-mock ../../Mock-RaaSI/Mock-ClientNodeSetup/files/kubernetes.list-mock
	cp ../../Mock-RaaSI/Mock-ClientNodeSetup/files/copy-files/10-kubeadm.conf-mock ../../Mock-RaaSI/Mock-ClientNodeSetup/files/10-kubeadm.conf-mock
	cd ../../Mock-RaaSI/Mock-ClientNodeSetup || exit
	touch results/clientSideNodeSetupResults
}
teardown(){
	rm results/clientSideNodeSetupResults
	cd ../../Tests/ClientNodeSetup || exit
}

@test "fstab modification" {
	./clientSideNodeSetup.sh
	expected="files/correct-files/fstab-mock"
	actual="files/fstab-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "kubernetes.list modification" {
	./clientSideNodeSetup.sh
	expected="files/correct-files/kubernetes.list-mock"
	actual="files/kubernetes.list-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "10-kubeadm.conf-mock modification" {
	./clientSideNodeSetup.sh
	expected="files/correct-files/10-kubeadm.conf-mock"
	actual="files/10-kubeadm.conf-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "response input validation failure blank" {
	./clientSideNodeSetup.sh
	result=$(cat results/clientSideNodeSetupResults)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./clientSideNodeSetup.sh "bad Argument"
	result=$(cat results/clientSideNodeSetupResults)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./clientSideNodeSetup.sh "Y"
	result=$(cat results/clientSideNodeSetupResults)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./clientSideNodeSetup.sh "y"
	result=$(cat results/clientSideNodeSetupResults)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./clientSideNodeSetup.sh "N"
	result=$(cat results/clientSideNodeSetupResults)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./clientSideNodeSetup.sh "n"
	result=$(cat results/clientSideNodeSetupResults)
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
