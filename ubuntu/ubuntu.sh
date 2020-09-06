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

#apt = apt-get、apt-cache 和 apt-config 中最常用命令选项的集合

beautify(){
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
    sudo apt install -y gnome-tweak-tool
    #list of adds on extension
    #dash to dock
    #dash to panel
    #system-monitor
    #sudo apt-get install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0
    #tray icon
    #user themes
    #clipboard indicator
    #cpu power manager
    #freon
}

mirrors(){
    sudo cp sources.list /etc/apt/
    sudo apt update
    sudo apt upgrade
}

timecheck(){
    sudo apt install -y ntpdate
    sudo ntpdate time.windows.com
    sudo hwclock --localtime --systohc
}

optimise(){
    sudo apt install -y preload #应用频率分析

    sudo add-apt-repository ppa:linrunner/tlp
    sudo apt update
    sudo apt install -y tlp tlp-rdw
    sudo tlp start
    sudo apt install -y indicator-cpufreq

    sudo add-apt-repository ppa:apt-fast/stable #apt-fast update
    sudo apt update
    sudo apt install -y apt-fast

}

application(){
    sudo apt install -y vim
    sudo cp vimrc /etc/vim/

    sudo apt install -y g++
    g++ -v
    sleep 5

    sudo add-apt-repository ppa:webupd8team/java
    sudo apt install -y openjdk-11-jdk
    java -version
    sleep 5

    sudo apt update && sudo apt install -y qbittorrent 
}

ch_java_vers_com(){
    sudo update-alternatives --config java
    # 查看并可选切换java版本
    # jdk 1.8.1(redhat) openjdk oracle 
    sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_181/bin/java 300
    sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_181/bin/javac 300
    # 添加java版本
    java -version
    sleep 5
}

mysql(){
    sudo apt update&& sudo apt install mysql-server && sudo mysql_secure_installation
}


winehq(){
    sudo dpkg --add-architecture i386 
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    sudo apt-key add winehq.key
    sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' 
    sudo apt update
    sudo apt install -y --install-recommends winehq-stable

    sudo apt install -y winetricks
    sudo apt install -y winbind

    winetricks dlls gdiplus
    winetricks dlls msxml6
    winetricks dlls msxml3
    winetricks dlls msxml4
    winetricks dlls corefonts
    winetricks dlls d3dx9 d3dcompiler_43 xact_jun2010
    winetricks dlls vcrun6 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2013 vcrun2015

    wget 'https://launchpad.net/takao-fonts/trunk/003.02.01/+download/takao-fonts-ttf-003.02.01.zip'
    mv ./takao-fonts-ttf-003.02.01.zip $HOME/.cache/winetricks/takao/takao-fonts-ttf-003.02.01.zip
    wget 'http://http.debian.net/debian/pool/main/f/fonts-baekmuk/fonts-baekmuk_2.2.orig.tar.gz'
    mv ./fonts-baekmuk_2.2.orig.tar.gz $HOME/.cache/winetricks/baekmuk/ttf-baekmuk_2.2.orig.tar.gz
    winetricks cjkfonts

}

nvidia(){
    sudo add-apt-repository ppa:graphics-drivers/ppa
    ubuntu-drivers devices
    read -p ":" num
    sudo apt-get install nvidia-driver-$num

    nvidia-smi
}

uninstall(){
    dpkg --list
    # 列出所安装的软件
    dpkg -L <programname>
    dpkg -l |grep <programname>
    # 列出软件安装目录

    #  " 卸载程序 sudo apt autoremove
    #  " sudo apt-get --purge remove <programname> 
    #  " 不保留配置文件
    #  " sudo apt-get remove <programname>
    #  " 保留配置文件
    
}



Main(){
    sudo passwd
    beautify
    if [ $? -eq 0 ]; then
        echo -e Msg_Success
    mirrors
    if [ $? -eq 0 ]; then
        echo -e Msg_Success
    timecheck
    if [ $? -eq 0 ]; then
        echo -e Msg_Success
    optimise
    if [ $? -eq 0 ]; then
        echo -e Msg_Success
    application
    if [ $? -eq 0 ]; then
        echo -e Msg_Success


}

Main 

