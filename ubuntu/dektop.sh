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

reboot_os() #重启本地主机
{
    echo
    echo -e "${Msg_Info}The system needs to reboot."
    read -p "${Msg_Warning}Restart takes effect immediately. Do you want to restart system? [y/n]" is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        reboot
    else
        echo -e "${Msg_Info}Reboot has been canceled..."
        exit 0
    fi
}

osInfo() #输出系统信息
{
    echo -e "${Msg_Info}Disk partitions and capacity remaining"
    df -h
    echo
    echo -e "${Msg_Info}Current memory status"
    free -h
    echo
    echo -e "${Msg_Info}Current Kernal info"
    uname -a
    echo
    echo -e "${Msg_Info}Output os infomation"
    neofetch 
    echo
    echo -e "${Msg_Info}Network quality test"
    speedtest
    echo
    read -p "${Msg_Success}press any key to Continue."
}

envirSetup() #环境安装与部署
{
    echo -e "${Msg_Info}terminal base envirment setup"
    sudo apt -y install net-tools wget curl firewalld #ifconfig
    sudo apt -y install python3-pip #above 18.04 lts
    sudo apt -y install screen tar #-xvf 解压 、-cvf 加压 
    sudo apt -y install vim git
    sudo apt -y install gcc 
    sudo apt -y install locate #文件搜索命令,find [路径] [文件属性]
    sudo apt -y update # update sources
    sudo apt -y upgrade # update software
    echo
    echo -e "${Msg_Info}java envirment setup"
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt -y install java-1.8.0-openjdk-1_amd64
    sudo update-java-alternatives -l #列举一系列的java安装版本
    sudo update-java-alternatives -s java-1.8.0-openjdk-amd64 #切换到指定的java版本 -s --select
    echo
    echo -e "${Msg_Info}os cache remove"
    sudo apt -y autoremove 
    sudo apt -y autoclean 
    echo
}

pluginSetup() #系统美化与可用插件
{
    echo -e "${Msg_Info}gnome UI adjustment plugin"
    sudo apt -y install gnome-tweak-tool 
    sudo apt -y install gnome-shell-extensions 
    sudo apt -y install gnome-shell-extension-dashtodock 
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize' #单击图标最小化
    echo
    echo -e "${Msg_info}os info read"
    sudo apt -y install neofetch
    echo
    echo -e "${Msg_info}network quality"
    sudo pip3 install speedtest_cli #command: speedtest
    echo
    echo -e "${Msg_Info}system monitor plugin"
    sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
    sudo apt -y install indicator-sysmonitor
    echo
    echo -e "${Msg_Info}lightness adjustment plugin"
    sudo add-apt-repository ppa:apandada1/brightness-controller 
    sudo apt -y install brightness-controller
    echo
}

AppSetup() #常用软件安装
{
    echo -e "${Msg_Info}chrome"
    sudo dpkg -i /media/zengke/MyPassport/Software/daliy/daliy.browser/google-chrome-stable_current_amd64.deb
    echo
    echo -e "${Msg_Info}qbittrrent"
    sudo apt install -y qbittorrent
    echo
    echo -e "${Msg_Info}vscode"
    sudo dpkg -i /media/zengke/MyPassport/Software/works/edit.code·Microsoft/linux/code_1.49.0-1599744551_amd64.deb
    echo
    echo -e "${Msg_Info}NetCloud music"
    sudo dpkg -i /media/zengke/MyPassport/Software/daliy/daliy.music.163/netease-cloud-music_1.2.1_amd64_ubuntu_20190428.deb
}

cudaSetup() #cuda开发环境安装
{
    echo -e "${Msg_Info}cuda setup"
    echo
    read -p "${Msg_Warning}Input your os edition(1804 or 2010):" ose
    if [[ ${ose} == "1804" ]]; then
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
        sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
        # wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
        # sudo dpkg -i cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
        sudo dpkg -i /media/zengke/MyPassport/Software/works/desTool.embedded.nvidia/cuda/cuda-repo-ubuntu1804-11-2-local_11.2.2-460.32.03-1_amd64.deb
        sudo apt-key add /var/cuda-repo-ubuntu1804-11-2-local/7fa2af80.pub
        sudo apt update
        sudo apt -y install cuda
        echo
        echo -e "${Msg_Info}You need manual install cuda-toolkit with 'apt -y install nvidia-cuda-toolkit'." # tips after exit
        read -p "${Msg_Success}press any key to Continue."
    else if [[ ${ose} == "2004" ]]; then
        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
        sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
        # wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.debsudo 
        # dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
        dpkg -i /media/zengke/MyPassport/Software/works/desTool.embedded.nvidia/cuda/cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
        sudo apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
        sudo apt update
        sudo apt -y install cuda
        echo
        echo -e "${Msg_Info}You need manual install cuda-toolkit with 'apt -y install nvidia-cuda-toolkit'." # tips after exit
        read -p "${Msg_Success}press any key to Continue."
    else
        echo -e "${Msg_Error}error input!"
        read -p "${Msg_Warning}again(yes or no):" ag
        if [[ ${ag} == "yes" || ${ag} == "y" ]]; then
            echo -e "${Msg_Info}cuda setup again."
            cudaSetup
        else
            echo -e "${Msg_Info}cuda setup stop."
            exit 0
        fi
    fi
    sudo apt autoclean # clean os cache
    sudo apt autoremove
}

sysTimeR() #同步系统时钟
{
    echo -e "${Msg_Info}Setup Time Service"
    sudo apt install -y ntpdate
    echo -e "${Msg_Info}Sync Time with Windows time zone"
    sudo ntpdate time.windows.com
    echo -e "${Msg_Success}Lock time with Hardware."
    sudo hwclock --localtime --systohc
}

systemRapair() #系统损坏插件修复
{
    sudo apt --fix-broken install
    sudo apt --fix-missing install
    # sudo dpkg -i --force-overwrite *.deb
    sudo apt -y upgrade
    sudo apt -y update
    sudo updatedb #更新文件系统
}

nvidiaVerify() #nvidia 有关的信息
{
    echo -e "${nvidia driver}"
    nvidia-smi 
    echo -e "${Msg_Info}cuda"
    nvcc -V
}

envirInfo() #系统环境相关的信息
{
    echo -e "${Msg_Info}version information."
    gcc --version
    java --version
    python --version
    python3 --version
    read -p "${Msg_Success}press any key to Continue."
}

main()
{
    clear
    date
    read -p "${Msg_Warning}Do you want to configure running envirment?(yes to configure or no to check):" tip
    echo -e "Get administrator privileges."
    sudo echo    
    if [[ ${tip} == "yes" || ${tip} == "y" ]]; then
        osInfo
        echo
        envirSetup
        pluinSetup
        AppSetup
        cudaSetup
        sysTimeR
        systemRapair
        reboot_os
    else
        osInfo
        echo
        systemRapair
        nvidiaVerify
        envirInfo
    fi    
    echo -e "${Msg_Success}done.\nexit 0"
}

main 2>&1 | tee ${START_PATH}/desktop_${CURTIME}.log
