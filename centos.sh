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
    yum -y install screen unzip tar
    yum -y install vim 
    yum -y install lvm2 lsmod lsof
    mv vimrc /etc/
    yum -y update       #更新全部安装，is same as yum upgarde
    
    pip3 install --upgrade pip
    
    echo
    echo -e "${Msg_Info}生产环境安装完成！\\n"
    sleep 2
}

Hardware_Check() {
    yum -y install lshw
#     lshw -version
#     lshw -short
#     cat /proc/cpuinfo 
}

System_Status() {
    curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo &&\
    yum -y install neofetch redhat-lsb-core
#     neofetch 
#     lsb_release -a      #系统信息
    
#     uname －a
#     cat /proc/version   #Linux查看当前操作系统版本信息 
#     getconf LONG_BIT  #查看系统位数
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

Firewall_Check() {
    systemctl start firewalld
    systemctl status firewalld
    firewall-cmd --zone=public --add-port=22/tcp --add-port=443/tcp --permanent
    firewall-cmd --reload 
    firewall-cmd --list-ports 
}

Kernel_Update() {
    yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm &&\    #导入epel-repo源 centos7
#     yum install -y https://www.elrepo.org/elrepo-release-8.0-2.el8.elrepo.noarch.rpm &&\
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org &&\                          #导入密钥
    yum clean all && rm -rf /var/cache/yum &&\                                              #清楚yum缓存
#     yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml &&\  #检查当前能安装的内核版本
    yum -y install --enablerepo=elrepo-kernel kernel-ml &&\                                 #安装最新内核
    vim /etc/default/grub &&\                                                               #将GRUB_TIMEOUT=5 改为 1 即等待 1 秒后启动
    grub2-mkconfig -o /boot/grub2/grub.cfg &&\                                              #重新生成启动菜单列表

    grubby --info=ALL &&\                                                                   #确认启动顺序，index=0 的内核版本应该等于刚刚更新的内核版本即为正确
    read -p  "enter the serial number of the recently installed kernel. [0/1/2...] " num &&\
    grub2-set-default $num &&\
    reboot_os
}

BBR_TCP_ON() {
    # wget "https://github.com/cx9208/bbrplus/raw/master/ok_bbrplus_centos.sh" && chmod +x ok_bbrplus_centos.sh && ./ok_bbrplus_centos.sh
    local param=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')
    if [[ x"${param}" != x"bbr" ]]; then
        modprobe tcp_bbr 
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf 
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf 
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf 
        sysctl -p  
    else
        echo -e "${Msg_Info}bbr already installed, Nothing to do...\n"
    fi
}

BBR_Check() {    
    lsmod | grep bbr
    sysctl net.ipv4.tcp_available_congestion_control 
    sysctl net.ipv4.tcp_congestion_control
    
    echo -e "${Msg_Success}\ntcp_bbr\nnet.ipv4.tcp_available_congestion_control = reno cubic bbr\nnet.ipv4.tcp_congestion_control = bbr"
}

Kernel_down() {
    rpm -qa |grep kernel                    #查询当前所有安装的内核版本
    grubby --info=ALL                       #确认启动顺序
    read -p  "enter the kernel serial number you want to downgrade. [0/1/2...] " num
    grub2-set-default $num
#     yum remove -y kernel-version          #移除
    reboot_os
}

Main() {
    clear
    Environment_Install &&\
    Hardware_Check &&\
    System_Status &&\
    Mermory_check &&\
    Net_Check &&\
    Firewall_Check 
    Kernel_Update
    BBR_TCP_ON
    BBR_Check
    yum clean all       #clean cache
}

Main 2>&1 |tee ${START_PATH}/SYS_result.txt
