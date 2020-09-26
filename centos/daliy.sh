#!/bin/bash
# ver 0.1
# date 7/5/2020
# anthour cnk
# for better comfortable

tansmission_Install() {
    yum -y install transmission-cli transmission-common transmission-daemon
    systemctl start transmission-daemon.service
    systemctl status transmission-daemon.service
    systemctl stop transmission-daemon.service
    echo '''
        "rpc-authentication-required": true,
        "rpc-enabled": true,
        "rpc-password": "password",
        "rpc-username": "username",
        "rpc-whitelist-enabled": false
        '''
    systemctl start transmission-daemon.service vim /var/lib/transmission/.config/transmission-daemon/settings.json
}
# caddy doesn't install anymore
# file manage & transfer would like to using filezilla

main() {
    firewall-cmd --zone=public --add-port=9091/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
    tansmission_Install
}

main 2>&1 | tee -a daliy_config.txt
