#!/bin/bash
# ver 0.1
# date 7/5/2020
# anthour cnk
# for better comfortable

tansmission_Install(){
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
    systemctl start transmission-daemon.service    vim /var/lib/transmission/.config/transmission-daemon/settings.json
}

caddy_Install(){
    wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh

    echo'''
    :80 {  
    root /path/to/downloads
    timeouts none  
    gzip  
    browse  
}''' > /usr/local/caddy/Caddyfile

    /etc/init.d/caddy start
}

main(){
    tansmission_Install
    caddy_Install

}

main  2>&1 |tee -a daliy_config.txt
