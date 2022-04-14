#!/usr/bin/env bats

setup(){
	cd ../../Mock-RaaSI/Mock-GlusterSetup || exit
	touch results/GlusterClientRaaSIResponse
	touch results/GlusterClientRaaSIStorageIp
}
teardown(){
	rm results/GlusterClientRaaSIResponse
	rm results/GlusterClientRaaSIStorageIp
	rm files/glusterfs-endpoints.yaml-mock
	cd ../../Tests/GlusterSetup || exit
}

@test "glusterfs-endpoint.yaml creation success" {
	./GlusterClientRaaSI.sh "y" "8.8.8.8"
	expected="files/correct-files/glusterfs-endpoint.yaml-mock"
	actual="files/glusterfs-endpoint.yaml-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "response input validation failure blank" {
	./GlusterClientRaaSI.sh
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "failed" ]
}

@test "response input validation failure illegal arg" {
	./GlusterClientRaaSI.sh "bad Argument"
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "failed" ]
}

@test "response input validation success Y" {
	./GlusterClientRaaSI.sh "Y"
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success y" {
	./GlusterClientRaaSI.sh "y"
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success N" {
	./GlusterClientRaaSI.sh "N"
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "passed" ]
}

@test "response input validation success n" {
	./GlusterClientRaaSI.sh "n"
	result=$(cat results/GlusterClientRaaSIResponse)
	[ "$result" == "passed" ]
}

@test "storage_ip input validation failure blank" {
	./GlusterClientRaaSI.sh "y"
	result=$(cat results/GlusterClientRaaSIStorageIp)
	[ "$result" == "failed" ]
}

@test "storage_ip input validation failure illegal argument" {
	./GlusterClientRaaSI.sh "y" "Bad Args"
	result=$(cat results/GlusterClientRaaSIStorageIp)
	[ "$result" == "failed" ]
}

@test "storage_ip input validation success" {
	./GlusterClientRaaSI.sh "y" "8.8.8.8"
	result=$(cat results/GlusterClientRaaSIStorageIp)
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
