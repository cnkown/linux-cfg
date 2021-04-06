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
    read -p "Restart takes effect immediately. Do you want to restart system? [y/n]" is_reboot
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
    echo
    neofetch
    speedtest
}

envirmentSetup() 
{
    apt install -y net-tools wget curl firewalld
    apt install -y java python3 python3-pip
    apt install -y screen tar
    apt install -y vim
    echo
    mv ../vimrc /etc/
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
}

bbrConfigure() 
{
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    echo
    if [[ x"${param}" != x"bbr" ]]; then
        modprobe tcp_bbr
        echo "tcp_bbr" >>/etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
        sysctl -p
    else
        echo "${Msg_Info}bbr already enabled, Nothing to do...\n"
    fi
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
    echo
    echo -e "${Msg_Info}clean cache"
    apt autoremove
    apt autoclean   
    echo 
    echo -e "${Msg_Info}network quality test"
    speedtest
    curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
    echo
}

v2raySetup()
{
    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    echo -e "${Msg_Info}"
}

transSetup()
{

}

nginxSetup()
{

}

main()
{
    clear
    date
    read -p "Do you want to configure running envirment?(yes to configure or no to check):" tip
    if [[${tip} == "yes" || ${tip} == "y"]]; then
        osInfo
        echo
        envirSetup
        reboot_os

        BBRturn
    else
        osInfo
        echo

        BBRverify
    fi    
}

main 2>&1 | tee ${START_PATH}/server_${CURTIME}.log
