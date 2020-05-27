#!/bin/bash

START_PATH=$(pwd)

v2ray_config() {
    bash <(curl -L -s https://install.direct/go.sh) &&\
    echo 'To get v2ray config with the follow url:'
    echo 'https://intmainreturn0.com/v2ray-config-gen/#'
    systemctl stop v2ray &&\
    vim /etc/v2ray/config.json &&\
    systemctl start v2ray &&\
    echo 'Remember opening firewall port just which one you set.'
    echo 'and the follow han been opened yed.'
    firewall-cmd --list-ports &&\
    echo 'firewall-cmd --zone=public --add-port=one/tcp --permanent'
    firewall-cmd --reload &&\
    firewall-cmd --list-ports
    systemctl status v2ray
}

transmission_install() {
    yum install transmission-cli transmission-common transmission-daemon &&\
    systemctl start transmission-daemon.service &&\
    systemctl status transmission-daemon.service &&\
    systemctl stop transmission-daemon.service &&\
    echo '
    "rpc-authentication-required": true,
    "rpc-enabled": true,
    "rpc-password": "password",
    "rpc-username": "username",
    "rpc-whitelist-enabled": false '    
    vim /var/lib/transmission/.config/transmission-daemon/settings.json
    systemctl start transmission-daemon.service
}

caddy_files() {
    wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh
    mkdir /var/lib/transmission/Downloads &&\ 
    chmod 777 /var/lib/transmission/Downloads
    echo ":80 {  
        root /var/lib/transmission/Downloads
        timeouts none  
        gzip  
        browse  
    }" > /usr/local/caddy/Caddyfile
    /etc/init.d/caddy start
} # few threads to downloads service

Main() {
    clear
    # v2ray_config
    transmission_install
    # caddy_files
    yum clean all       #clean cache
}

Main 2>&1 |tee ${START_PATH}/Daliy.txt
