# linux eassy configure
linux configure shell files

注意事项：
1、500G容量分区
  512MiB /efi
  100GiB /root
  60GiB /var
  60GiB /var/local
  250GiB /home
  other /swap-area

2、插件
  tweak-tool\
  qbittorrent\
  vscode\
  netease music\
  chrome-stale\
  sdk manager
  
3、cuda runtime
  cuda-toolkit：添加源、安装包获取、释放数据、更新源、安装 %相关链接 https://developer.nvidia.com/cuda-downloads
  更新文件 apt upgrade
  修复文件 apt --fix-broken --install
  强制覆盖文件 dpkg -i --force-overwrite *.deb
  清除缓存 apt autoclean && apt autoremove
  重启操作系统 reboot
  
