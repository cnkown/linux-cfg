# linux auto shell
for desktop and server

tips：
1、500GiB disk
  512MiB /efi
  100GiB /root
  60GiB /var
  60GiB /var/local
  250GiB /home
  other /swap-area

2、plugin
  tweak-tool\
  qbittorrent\
  vscode\
  netease music\
  chrome-stale\
  sdk manager
  
3、cuda runtime
  cuda-toolkit：add repository, get software package, release cache, update repository, install software. link: https://developer.nvidia.com/cuda-downloads
  something commands with related.
  update software verison: apt upgrade
  fixing broken software: apt --fix-broken --install
  force overwrite software: dpkg -i --force-overwrite *.deb
  clear cache and remove alone software packages: apt autoclean && apt autoremove
  rebooting: reboot
  
4、git proxy speedup
  git config --global http.proxy "http://127.0.0.1:1081"
  git config --global https.proxy "http://127.0.0.1:1081"
  
  cancel proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy

