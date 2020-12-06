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

environment_Install() {
    apt -y install net-tools wget curl firewalld
    apt -y install gcc python3 python3-pip
    apt -y install screen tar
    apt -y install vim
    cd ..
    mv vimrc /etc/
    cd $START_PATH
    apt -y update #更新全部安装，is same as apt upgarde
    pip3 install --upgrade pip
    echo -e "${Msg_Info}生产环境安装完成！\\n"
    sleep 2
}

firewall_on() {
    systemctl start firewalld
    systemctl enable firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=22/tcp --add-port=443/tcp --add-port=2443/tcp --add-port=26929/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-ports
}

hardware_Check() {
    apt -y install lshw
}

system_Status() {
    apt -y install neofetch 
}

mermory_check() {
    cat /etc/fstab
    fdisk -l
    df -h
    free -h
}

net_Check() {
    pip3 -y install speedtest_cli
    wget https://ilemonra.in/LemonBenchIntl && mv LemonBenchIntl LemonBenchIntl.sh && chmod u+x LemonBenchIntl.sh && \
}

main() {
    clear
    mermory_check && \
    environment_Install && \
    firewall_on && \
    hardware_Check && \
    system_Status && \
    net_Check && \
    kernel_Update
    apt clean all #clean cache
}

mkdir logs && cd logs && df -h | tee -a memory.txt && free -h | tee -a memory.txt && \
cd ${START_PATH}
main 2>&1 | tee ${START_PATH}/system_config.txt
