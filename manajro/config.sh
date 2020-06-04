#!/bin/sh

PATH=$(pwd)

# mirror-envir-software-biuti
# pacman -S --sync
# -R, --remove
# -U, --upgrade
# -c, --cascade
# -y, --refresh
# pacman -Sy
# pacman -Syy
# pacman -Rs 删除指定软件包，及其所有没有被其他已安装软件包使用的依赖关系
# pacman -Rsc 要删除软件包和所有依赖这个软件包的程序

MirrorsCM(){
    sudo pacman-mirrors -i -c China -m rank
    sudo pacman -Syu

    sudo echo '''
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
''' >> /etc/pacman.conf

    sudo pacman -Sy archlinuxcn-keyring
    sudo pacman -Syy

    sudo pacman -Sy yay base-devel
    sudo pacman -Sy yaourt

    sudo pacman -Syyu
}

SoftIns(){
    pip install speedtest_cli
    sudo pacman -Sy neofetch

    sudo pacman -Sy netease-cloud-music
    sudo pacman -Sy google-chrome
    sudo pacman -Sy wps-office
    sudo pacman -Sy net-tools
    yay -Sy ttf-wps-fonts
    sudo pacman -Sy git
    sudo pacman -Sy vim
    sudo pacman -Sy code

    wget https://dl.motrix.app/release/Motrix-1.5.10.AppImage -P ~/Downloads
    wget https://github.com/Dr-Incognito/V2Ray-Desktop/releases/download/2.1.4/V2Ray-Desktop-v2.1.4-linux-x86_64.AppImage -P ~/Downloads
    wget https://github.com/v2ray/v2ray-core/releases/download/v4.23.4/v2ray-linux-64.zip -P ~/Downloads
    
    yay -Sy gtk-theme-arc-git
    # icon theme
    # mcmojava
}

EnvirConfig(){
    # oh-my-shell
    chsh -s /bin/zsh
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    # theme show
    firefox https://github.com/ohmyzsh/ohmyzsh/wiki/themes
    # theme change
    echo '''ZSH_THEME="want_theme"'''
    code ~/.zshrc
    source ~/.zshrc 
    # autofill
    wget http://mimosa-pudica.net/src/incr-0.2.zsh
    mv incr-0.2.zsh .oh-my-zsh/plugins/incr/
    echo '''
source ~/.oh-my-zsh/plugins/incr/incr*.zsh
''' >> ~/.zshrc
    source ~/.zshrc 
}

InputMethod(){
    sudo pacman -Sy ibus-rime ibus-pinyin
    echo '''
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -x -d
''' >> ~/.xprofile
}

SysClean(){
    sudo pacman -R $(pacman -Qdtq) # 清除系统中无用的包
    sudo pacman -Scc # 清除已下载的安装包
    sudo rm /var/lib/systemd/coredump/* # 清理崩溃日志
}


Main(){
    clear
    MirrorsCM
    SoftIns
    EnvirConfig
    InputMethod
    SysClean
    echo "your system need reboot"
}

Main 2>&1 |tee ${PATH}/manjaroconfig.txt

