#!/usr/bin/env bats

setup(){
	cp ../../Mock-RaaSI/Mock-GlusterSetup/files/copy-files/gluster.list-mock ../../Mock-RaaSI/Mock-GlusterSetup/files/gluster.list-mock
	cd ../../Mock-RaaSI/Mock-GlusterSetup || exit
}
teardown(){
	rm files/gluster.list-mock
	cd ../../Tests/GlusterSetup || exit
}

@test "gluster.list modification" {
	./GlusterInstallationNode.sh
	expected="files/correct-files/gluster.list-mock"
	actual="files/gluster.list-mock"
	result=$(../test.sh $expected $actual)
	[ "$result" == "good" ]
}

#@test "addition using bc" {
#        result="$(echo 2+2 | bc)"
#        [ "$result" -eq 4 ]
#}

#@test "addition using dc" {
#        result="$(echo 2 2+p | dc)"
#        [ "$result" -eq 4 ]
#}
