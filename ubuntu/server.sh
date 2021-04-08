#!/bin/bash

# 字体颜色定义
Font_Black="\033[30m"
Font_Red="\033[31m"
Font_Green="\033[32m"
Font_Yellow="\033[33m"
Font_Blue="\033[34m"
Font_Purple="\033[35m"
Font_SkyBlue="\033[36m"
Font_White="\033[37m"
Font_Suffix="\033[0m"

# 消息提示定义
Msg_Info="${Font_Blue}[Info] ${Font_Suffix}"
Msg_Warning="${Font_Yellow}[Warning] ${Font_Suffix}"
Msg_Debug="${Font_Yellow}[Debug] ${Font_Suffix}"
Msg_Error="${Font_Red}[Error] ${Font_Suffix}"
Msg_Success="${Font_Green}[Success] ${Font_Suffix}"
Msg_Fail="${Font_Red}[Failed] ${Font_Suffix}"

START_PATH=$(pwd)
CURTIME=$(date "+%Y%m%d%H%M%S")

reboot_os() 
{
    echo 0
    echo -e "${Msg_Info}The system needs to reboot."
    read -p "${Msg_Warning}Restart takes effect immediately. Do you want to restart system? [y/n]" is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        reboot
    else
        echo -e "${Msg_Info}Reboot has been canceled..."
        exit 0
    fi
}

infoBase() 
{
    df -h
    free -h
    uname -a
}

envirmentSetup() 
{
    apt install -y net-tools wget curl firewalld
    apt install -y java python3 python3-pip
    apt install -y screen tar
    apt install -y vim
    echo
    mv /etc/vimrc /etc/vimrc.bak
    cp ${START_PATH}/../vim_cfg/vimrc /etc/vimrc
    pip3 install --upgrade pip
    echo
    apt -y update
    apt -y upgrade
    apt -y autoclean
    apt -y autoremove
}

firewallSetup() 
{
    systemctl start firewalld
    systemctl enable firewalld
    systemctl status firewalld
    echo
    firewall-cmd --zone=public --add-port=22/tcp --add-port=443/tcp --add-port=2443/tcp --add-port=26929/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
}

infoConfigure() 
{
    apt install -y neofetch 
    pip3 install speedtest_cli
    echo
    wget https://ilemonra.in/LemonBenchIntl 
    mv LemonBenchIntl LemonBenchIntl.sh 
    chmod u+x LemonBenchIntl.sh 
    echo -e "${Msg_Info}Test Network with comand:LemonBenchIntl.sh -s fast"
    read -p "${Msg_Success}press any key to Continue."
}

bbrConfigure() 
{
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    echo
    if [[ x"${param}" != x"bbr" ]]; then
        modprobe tcp_bbr
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p
    else
        echo "${Msg_Info}bbr already enabled, Nothing to do...\n"
    fi
}

v2raySetup()
{
    echo -e "${Msg_Info}You need to manually configure V2RAY after installation complete."
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    echo -e "${Msg_Success}V2RAY direction is：/usr/local/etc/v2ray/"
    read -p "${Msg_Warning}Do you want to using local v2ray file?(yes to local cfg or no to weblink)" V2_CFG
    if [[ ${V2_CFG} == "yes" || ${V2_CFG} == "y" ]]; then
        echo -e "${Msg_Success}you need config v2ray id. and last v2ray configure file has been bakup."
        mv /usr/local/etc/v2ray/config.json /usr/local/etc/v2ray/config.json.bak
        cp ${START_PATH}/../v2ray_cfg/v2ray.config.json /usr/local/etc/v2ray/config.json
        cat /usr/local/etc/v2ray/config.json.bak
        echo -e "${Msg_Info}replace xxx with bak id."
        vim /usr/local/etc/v2ray/config.json
        echo -e "${Msg_Info}register v2ray service in system."
        systemctl enable v2ray
        echo -e "${Msg_Info}loading v2ray service in system."
        systemctl start v2ray
        echo -e "${Msg_Info}show v2ray service status."
        systemctl status v2ray
        read -p "${Msg_Warning}If error,rapired it with tips."
    else
        echo -e "${Msg_Info}Manual config by yourself later." 
        echo -e "${Msg_Info}web link: https://intmainreturn0.com/v2ray-config-gen/#"
        echo -e "${Msg_Info}echo command to /usr/local/etc/v2ray/config.json"
        read -p "${Msg_Warning}INCOMPLETED.\npress any key to continue."
    fi
    echo -e "${Msg_Info}善用systemctl命令\nsystemctl enable v2ray:注册v2ray自启动服务\nsystemctl start v2ray:启动v2ray服务\nsystemctl status v2ray:查询v2ray服务\nsystemctl stop v2ray:终止v2ray服务"
    read -p "${Msg_Success}press any key to Continue."
}

transSetup()
{
    echo -e "${Msg_Info}setup transmission remote server download service"
    apt install -y transmission-cli transmission-common transmission-daemon
    mkdir /var/lib/transmission-daemon/downloads #创建下载服务文件夹
    echo -e "${Msg_Info}Stop download service"
    systemctl stop transmission-daemon.service
    read -p "${Msg_Warning}Do you want to configure manually?(yes to manually or no to using configure file.)" TRN_CFG
    if [[ ${TRN_CFG} == "yes" || ${TRN_CFG} == "y" ]]; then 
        echo -e "${Msg_Info}rpc-authentication-required: true,\n  rpc-enabled: true,\n  rpc-password: password,\n  rpc-username: username,\n  rpc-whitelist-enabled: false"
        vim /var/lib/transmission/.config/transmission-daemon/settings.json
    else
        mv /var/lib/transmission-daemon/.config/transmission-daemon/settings.json /var/lib/transmission-daemon/.config/transmission-daemon/settings.json.bak
        cp ${START_PATH}/transmission/transmission.settings.json /var/lib/transmission-daemon/.config/transmission-daemon/settings.json
        echo -e "${Msg_Warning}PLEASE CONFIGURE PASSWORD."
        vim /var/lib/transmission-daemon/.config/transmission-daemon/settings.json
    fi
    echo -e "${Msg_Info}register transmission service"
    systemctl enable transmission-daemon.service
    echo -e "${Msg_Info}loading transmission service"
    systemctl start transmission-daemon.service
    echo -e "${Msg_Info}show transmission service status"
    systemctl status transmission-daemon.service
    echo
    echo -e "${Msg_Info}enable firewall for transmission service"
    firewall-cmd --zone=public --add-port=9091/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
    echo -e "${Msg_Info}your configure is follows."
    cat /var/lib/transmission-daemon/.config/transmission-daemon/settings.json
    read -p "${Msg_Success}press any key to Continue."
}

nginxSetup()
{
    echo -e "${Msg_Info}setup remote server with nginx service"
    apt install -y nginx
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
    cp ${START_PATH}/nginx/nginx.conf /etc/nginx/nginx.conf
    echo -e "${Msg_Info}register nginx service"
    systemctl enable nginx
    echo -e "${Msg_Info}loading nginx service"
    systemctl start nginx
    echo -e "${Msg_Info}show nginx service status"
    systemctl status nginx
    echo
    echo -e "${Msg_Info}enable firewall for nginx service"
    firewall-cmd --zone=public --add-port=8080/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
    echo
    echo -e "${Msg_Info}your configure is follows."
    cat /etc/nginx/nginx.conf
    read -p "${Msg_Success}press any key to Continue."
}

osInfo() 
{
    echo -e "${Msg_Info}os info check"    
    df -h
    free -h
    uname -a
    neofetch    
    echo
    echo -e "${Msg_Info}show server bbr status"
    lsmod | grep bbr
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    echo -e "${Msg_Success}tcp_bbr\nnet.ipv4.tcp_available_congestion_control = reno cubic bbr\nnet.ipv4.tcp_congestion_control = bbr"
    read
    echo -e "${Msg_Info}clean cache"
    apt autoremove
    apt autoclean   
    echo 
    echo -e "${Msg_Info}network quality test"
    speedtest
    read -p "${Msg_Warning}是否进行网络压力测试？(yes:进行网络压力测试，no:不进行网络压力测试)" NetBench
    if [[ ${NetBench} == "yes" || ${NetBench} == "y" ]]; then
        curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
    fi
    echo
}

main()
{
    clear
    date
    read -p "${Msg_Warning}Do you want to configure running envirment?(yes to configure or no to check):" tip
    if [[ ${tip} == "yes" || ${tip} == "y" ]]; then
        infoBase
        echo
        envirmentSetup
        firewallSetup
        infoConfigure
        bbrConfigure
        read -p "${Msg_Warning}Do you want to install v2ray service?[y/n]" V2R
        if [[ ${V2R} == "y" || ${V2R} == "Y" ]]; then
            v2raySetup
        fi
        read -p "${Msg_Warning}Do you want to install transmission for download service?[y/n]" TRS
        if [[ ${TRS} == "y" || ${TRS} == "Y" ]]; then
            transSetup
        fi
        read -p "${Msg_Warning}Do you want to install nginx for web service?[y/n]" NGX
        if [[ ${NGX} == "y" || ${NGX} == "Y" ]]; then
            nginxSetup
        fi
        reboot_os
    else
        osInfo
    fi    
}

main 2>&1 | tee ${START_PATH}/server_${CURTIME}.log
