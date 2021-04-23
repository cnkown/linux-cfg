# linux eassy start
desktop&server configure shell script

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
  清除缓存以及孤立软件包 apt autoclean && apt autoremove
  重启操作系统 reboot
  
4、git 代理加速
  git config --global http.proxy "http://127.0.0.1:1081"
  git config --global https.proxy "http://127.0.0.1:1081"
  
  消除代理
  git config --global --unset http.proxy
  git config --global --unset https.proxy

