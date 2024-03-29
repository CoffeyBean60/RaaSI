! /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
    router_id LVS_DEVEL
}
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  weight -2
  fall 10
  rise 2
}

vrrp_instance VI_1 {
    state BACKUP
    interface ens18
    virtual_router_id 52
    priority 100
    authentication {
        auth_type PASS
        auth_pass 40
    }
    virtual_ipaddress {
        192.168.7.60
    }
    track_script {
        check_apiserver
    }
}
