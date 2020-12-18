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

reboot_os() {
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

devCheck() {
    cat /etc/fstab
    fdisk -l
    df -h
    free -h
    uname -a
}

envirInstall() {
    apt install -y net-tools wget curl firewalld
    apt install -y gcc python3 python3-pip
    apt install -y screen tar
    apt install -y vim
    mv ../vimrc /etc/
    apt -y update
    pip3 install --upgrade pip
    echo -e "${Msg_Info}生产环境安装完成！\\n"
    sleep 2
}

firewallON() {
    systemctl start firewalld
    systemctl enable firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=22/tcp --add-port=443/tcp --add-port=2443/tcp --add-port=26929/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
}

sysInformation() {
    apt install -y neofetch 
    pip3 install speedtest_cli
    wget https://ilemonra.in/LemonBenchIntl && mv LemonBenchIntl LemonBenchIntl.sh && chmod u+x LemonBenchIntl.sh && \
}

bbrTCPON() {
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    if [[ x"${param}" != x"bbr" ]]; then
        modprobe tcp_bbr
        echo "tcp_bbr" >>/etc/modules-load.d/modules.conf
        echo "net.core.default_qdisc=fq" >>/etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >>/etc/sysctl.conf
        sysctl -p
    else
        echo "${Msg_Info}bbr already installed, Nothing to do...\n"
    fi

}

ENDCheck() {
    lsmod | grep bbr
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control

    echo -e "${Msg_Success}\ntcp_bbr\nnet.ipv4.tcp_available_congestion_control = reno cubic bbr\nnet.ipv4.tcp_congestion_control = bbr"
    
    neofetch
    
    speedtest
    curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
}

main() {
    clear
    devCheck
    apt update
    envirInstall
    firewallON 
    sysInformation

    bbrTCPON
    ENDCheck
    reboot_os
    apt clean all
}

mkdir logs && cd logs && df -h | tee -a memory.txt && free -h | tee -a memory.txt 
main 2>&1 | tee ${START_PATH}/system_config.txt
