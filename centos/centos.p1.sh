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
    echo
    echo -e "${Msg_Info}The system needs to reboot."
    read -p "Restart takes effect immediately. Do you want to restart system? [y/n]" is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        reboot
    else
        echo -e "${Msg_Info}Reboot has been canceled..."
        exit 0
    fi
}

Environment_Install() {
    yum -y install epel-release
    yum -y install net-tools wget curl firewalld
    yum -y install java gcc python3 python3-pip
    yum -y install screen tar
    yum -y install vim 
    yum -y install lsmod lsof
    cd .. 
    mv vimrc /etc/
    cd centos
    yum -y update       #更新全部安装，is same as yum upgarde
    
    pip3 install --upgrade pip
    
    echo
    echo -e "${Msg_Info}生产环境安装完成！\\n"
    sleep 2
}

Firewall_on() {
    systemctl start firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=22/tcp --add-port=80/tcp --add-port=443/tcp --add-port=2443/tcp --add-port=9091/tcp --permanent
    firewall-cmd --reload 
    firewall-cmd --list-ports 
}

Hardware_Check() {
    yum -y install lshw
}

System_Status() {
    curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo &&\
    yum -y install neofetch redhat-lsb-core
}

Mermory_check() {
    cat /etc/fstab
    fdisk -l
    df -h
    free -h
}

Net_Check() {
    pip3 install speedtest_cli
    speedtest
#     curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast #LemonBench;硬件、网络压力测试
    
    mkdir Speedtest_Shell && cd Speedtest_Shell &&\
    wget https://ilemonra.in/LemonBenchIntl && mv LemonBenchIntl LemonBenchIntl.sh && chmod u+x LemonBenchIntl.sh &&\
    cd $START_PATH
}

Kernel_Update() {
    yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm &&\    #导入epel-repo源 centos7
#     yum install -y https://www.elrepo.org/elrepo-release-8.0-2.el8.elrepo.noarch.rpm &&\
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org &&\                          #导入密钥
    yum clean all && rm -rf /var/cache/yum &&\                                              #清楚yum缓存
#     yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml &&\  #检查当前能安装的内核版本
    yum -y install --enablerepo=elrepo-kernel kernel-ml &&\                                 #安装最新内核
    echo '将GRUB_TIMEOUT=5 改为 1 即等待 1 秒后启动'
    vim /etc/default/grub &&\                                                               #将GRUB_TIMEOUT=5 改为 1 即等待 1 秒后启动
    grub2-mkconfig -o /boot/grub2/grub.cfg &&\                                              #重新生成启动菜单列表
    echo '#确认启动顺序，index=0 的内核版本应该等于刚刚更新的内核版本即为正确'
    grubby --info=ALL &&\                                                                   #确认启动顺序，index=0 的内核版本应该等于刚刚更新的内核版本即为正确
    read -p  "enter the serial number of the recently installed kernel. [0/1/2...] " num &&\
    grub2-set-default $num &&\
    reboot_os
}

Main() {
    clear
    Mermory_check &&\
    Environment_Install &&\
    Firewall_on &&\
    Hardware_Check &&\
    System_Status &&\
    Net_Check &&\
    Kernel_Update

    yum clean all       #clean cache
}

Main 2>&1 |tee ${START_PATH}/system_config.txt

