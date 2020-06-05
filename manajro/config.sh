#!/bin/bash


# mirror-envir-software-biuti
# pacman -Sy 仅同步源
# pacman -Syu 同步源并更新系统
# pacman -R 仅删除包
# pacman -Rc 删除包和依赖包
# pacman -Rsn 删除程序文件以及所有依赖包并删除配置文件
# pacman -Sc 清除pkg目录下的旧数据
# pacman -Scc 清除所有下载的包和数据库
# pacman -U 安装本地软件包,pkg.tar.gz

MirrorsCM(){
    echo "checking china mirrors,waitting......"
    pacman-mirrors -i -c China -m rank
    pacman -Sy

    echo '''
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
''' >> /etc/pacman.conf

    pacman -S archlinuxcn-keyring
    pacman -Sy

    pacman -Sy yay base-devel --noconfirm
    pacman -Sy yaourt --noconfirm

    pacman -Syu
}

SoftIns(){
    pip install speedtest_cli
    pacman -Sy neofetch --noconfirm

    pacman -Sy netease-cloud-music --noconfirm
    pacman -Sy google-chrome --noconfirm
    pacman -Sy wps-office --noconfirm
    pacman -Sy net-tools --noconfirm
    yay -Sy ttf-wps-fonts --noconfirm
    pacman -Sy git --noconfirm
    pacman -Sy vim --noconfirm
    pacman -Sy code --noconfirm

    wget https://dl.motrix.app/release/Motrix-1.5.10.AppImage -P /home/ke/Downloads
    wget https://github.com/Dr-Incognito/V2Ray-Desktop/releases/download/2.1.4/V2Ray-Desktop-v2.1.4-linux-x86_64.AppImage -P /home/ke/Downloads
    wget https://github.com/v2ray/v2ray-core/releases/download/v4.23.4/v2ray-linux-64.zip -P /home/ke/Downloads
    
    yay -Sy gtk-theme-arc-git --noconfirm
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
    code /home/ke/.zshrc
    source /home/ke/.zshrc 
    # autofill
    wget http://mimosa-pudica.net/src/incr-0.2.zsh
    mv incr-0.2.zsh .oh-my-zsh/plugins/incr/
    echo '''
source /home/ke/.oh-my-zsh/plugins/incr/incr*.zsh
''' >> /home/ke/.zshrc
    source /h ome/ke/.zshrc 
}

InputMethod(){
    pacman -Sy ibus-rime ibus-pinyin --noconfirm
    echo '''
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -x -d
''' >> /home/ke/.xprofile
}

SysClean(){
    pacman -R $(pacman -Qdtq) --noconfirm
    pacman -Scc --noconfirm
    rm /var/lib/systemd/coredump/*  --noconfirm

}


Main(){
    clear
    MirrorsCM
    SoftIns
    EnvirConfig
    InputMethod
    SysClean
    reboot
}

Main 2>&1 | tee -a /home/ke/Documents/manjaroconfig.txt

