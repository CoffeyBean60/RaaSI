#!/usr/bin/env bats

setup(){
	cp ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/copy-files/check_apiserver.sh.all-mock ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/check_apiserver.sh.all-mock
	cp ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/copy-files/haproxy.cfg.all-mock ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/haproxy.cfg.all-mock
	cp ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/copy-files/keepalived.conf.primary-mock ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/keepalived.conf.primary-mock
	cp ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/copy-files/keepalived.conf.secondary-mock ../../Mock-RaaSI/Mock-LoadBalancerSetup/files/keepalived.conf.secondary-mock
	cd ../../Mock-RaaSI/Mock-LoadBalancerSetup || exit
	touch results/LBInstallationLBIp
	touch results/LBInstallationInterface
	touch results/LBInstallationClientUser
}
teardown(){
	rm results/LBInstallationLBIp
	rm results/LBInstallationInterface
	rm results/LBInstallationClientUser
	cd ../../Tests/LoadBalancerSetup || exit
}

@test "check_apiserver.sh.all modification" {
	./LBInstallation.sh "8.8.8.8" "eth" "user"
	expected="files/correct-files/check_apiserver.sh.all-mock"
	actual="files/check_apiserver.sh.all-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "haproxy.cfg.all modification" {
	./LBInstallation.sh "8.8.8.8" "eth" "user"
	expected="files/correct-files/haproxy.cfg.all-mock"
	actual="files/haproxy.cfg.all-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "keepalived.conf.primary modification" {
	./LBInstallation.sh "8.8.8.8" "eth" "user"
	expected="files/correct-files/keepalived.conf.primary-mock"
	actual="files/keepalived.conf.primary-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

@test "keepalived.conf.primary modification" {
        ./LBInstallation.sh "8.8.8.8" "eth" "user"
        expected="files/correct-files/keepalived.conf.secondary-mock"
        actual="files/keepalived.conf.secondary-mock"
        result=$(../test.sh $expected $actual)
        [ "$result" == "good" ]
}

@test "LB_ip input validation failure blank" {
	./LBInstallation.sh
	result=$(cat results/LBInstallationLBIp)
	[ "$result" == "failed" ]
}

@test "LB_ip input validation failure illegal argument" {
        ./LBInstallation.sh "Bad Args"
        result=$(cat results/LBInstallationLBIp)
        [ "$result" == "failed" ]
}

@test "LB_ip input validation success" {
        ./LBInstallation.sh "8.8.8.8" "2" "3"
        result=$(cat results/LBInstallationLBIp)
        [ "$result" == "passed" ]
}

@test "interface input validation failure blank" {
        ./LBInstallation.sh "8.8.8.8"
        result=$(cat results/LBInstallationInterface)
        [ "$result" == "failed" ]
}

@test "interface input validation failure illegal argument" {
        ./LBInstallation.sh "8.8.8.8" "!Good" "3"
        result=$(cat results/LBInstallationInterface)
        [ "$result" == "failed" ]
}

@test "interface input validation success" {
        ./LBInstallation.sh "8.8.8.8" "eth" "3"
        result=$(cat results/LBInstallationInterface)
        [ "$result" == "passed" ]
}

@test "client_user input validation failure blank" {
        ./LBInstallation.sh "8.8.8.8" "eth"
        result=$(cat results/LBInstallationClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation failure illegal argument" {
        ./LBInstallation.sh "8.8.8.8" "eth" "!Good"
        result=$(cat results/LBInstallationClientUser)
        [ "$result" == "failed" ]
}

@test "client_user input validation success" {
        ./LBInstallation.sh "8.8.8.8" "eth" "user"
        result=$(cat results/LBInstallationClientUser)
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
