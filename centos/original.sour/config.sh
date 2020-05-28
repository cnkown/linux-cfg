#!bin/bash
# 
# #----------------------------------------------------------------------------------#
# |                                     config.sh                                   |
# #---------------------------------------------------------------------------------#
# |Create time:11/23/2019 7:22PM                                                    |
# |&&:上一个命令运行完毕之后接着运行,which name:查询程序所在位置, \:bash shell         |
# |epel（extra packages for enterprise linux）是由 Fedora 社区打造                   |
# |为RHEL及衍生发行版提供高质量软件包的项目，装EPEL,第三方源                           |
# |     bash <(curl -L -s https://install.direct/go.sh)  :v2                        |
# |     systemctl enable/start/stop/restart service.name/v2ray                      |
# |     bash <(curl -s -L https://git.io/v2ray.sh)  :v2+cdn   
# |     https://intmainreturn0.com/v2ray-config-gen/#
# |     变量设定之后的调用符号$,调用出变量中的内容,那样才有意义                        |
# |注意防火墙对端口的禁用，服务后面加不加service都可以                                 |
# |#---------------------------------------------------------------------------------#


screen -S [name] # 窗口运行 
Ctrl ad #转入后台 
Ctrl d #终止窗口
screen -r [name] #返回窗口

# 端口检查
netstat -an             # //查看网络端口 
netstat -anp            # //显示系统端口使用情况
netstat -ntlp           # //查看当前所有tcp端口[-t:tcp;-u:udp;-l:套接字，程序能够读写、收发通讯协议有关的程序；-p:进程标识符和名称，-n:不进行dns查询，显式ip]
lsof -i                 # //查看当前程序正在使用网络全部端口
lsof -i :port           # //使用lsof -i :port就能看见所指定端口运行的程序，同时还有当前连接。 

# 工具安装
yum install -y epel-release
yum install             # 没有指定即全部安装
yum groupinsall         # 安装程序组
yum provides */wants    # 查询想要的工具所在的组，解析出来之后最好详细指定安装包

yum -y install net-tools wget curl 
yum -y install java gcc python3 python3-pip 
yum -y install screen unzip tar vim lvm2 #生产环境 net-tools 是ifconfig lvm2是pvscan
yum -y install lsof lsmod 
pip3 install --upgrade pip


# 工具升级
yum update               #全部更新
yum check-update         #检查可更新的程序
yum groupupdate          #升级程序组

# 内核升级??bbr
yum install -y https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm    #导入epel-repo源 centos7
# yum install -y https://www.elrepo.org/elrepo-release-8.0-2.el8.elrepo.noarch.rpm
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org                          #导入密钥
yum clean all && rm -rf /var/cache/yum                                              #清楚yum缓存
# yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml  #检查当前能安装的内核版本
yum -y install --enablerepo=elrepo-kernel kernel-ml                                 #安装最新内核
vim /etc/default/grub                                                               #将GRUB_TIMEOUT=5 改为 1 即等待 1 秒后启动
grub2-mkconfig -o /boot/grub2/grub.cfg                                              #重新生成启动菜单列表
grubby --info=ALL                                                                   #确认启动顺序，index=0 的内核版本应该等于刚刚更新的内核版本即为正确
read -p  "${Msg_Warning}Enter the serial number of the recently installed kernel." num
grub2-set-default $num
reboot

wget "https://github.com/cx9208/bbrplus/raw/master/ok_bbrplus_centos.sh" && chmod +x ok_bbrplus_centos.sh && ./ok_bbrplus_centos.sh

# 程序安装
# yum安装
yum list installed
# yum list installed |grep [program]

# git 的项目编译安装
./configraue && make &&make install
# 源码包也没有提供make uninstall，则可以通过以下方式可以完整卸载：找一个临时目录重新安装一遍
# ./configure --prefix=/tmp/to_remove && make install

# 解压安装方式
# unzip -d xx xx.zip
# //配置程序文件/etc/profile

'''
卸载现有Git
yum remove git

编译安装最新的git版本
cd /usr/local/src/
wget https://www.kernel.org/pub/software/scm/git/git-2.22.2.tar.xz
tar -vxf git-2.22.2.tar.xz
cd git-2.22.2
make prefix=/usr/local/git all
make prefix=/usr/local/git install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
source /etc/profile

git --version
git version 2.22.2

如果是非root用户使用git，则需要配置下该用户下的环境变量

echo "export PATH=$PATH:/usr/local/git/bin" >> ~/.bashrc
source ~/.bashrc
'''


# 工具查看，加grep查看指定
#①rpm包安装的
rpm -qa | grep [name]
#②以deb包安装的
dpkg -l | grep [name]
#③yum方法安装的 
yum list [name] #查询可安装
yum list installed | grep [name] #对安装的包进行查询，以便于完全卸载
#④以源码包自己编译安装的，查看文件是否存在/sbin；/usr/bin

# 工具移除，e进入卸载模式
# rpm -e [name] {--nodeps} #剔除有关依赖，不管其他
# yum remove [name]


# 硬件查看
yum install -y lshw redhat-lsb-core
lshw --version
lshw -short
cat /proc/cpuinfo # （Linux查看cpu相关信息，包括型号、主频、内核信息等）

# 文件状态显示
cat /etc/fstab #磁盘配置现状
free -m #内存、交换区剩余mb
fdisk -l #磁盘配置量
df -h <h:human k:kB m:mB> #磁盘数据使用量
ll -h #当前文件列出，文件的大小单位kmg
ll -ah #列出当前所有文件目录，文件的大小单位kmg

# 系统查看
curl -o /etc/yum.repos.d/konimex-neofetch-epel-7.repo https://copr.fedorainfracloud.org/coprs/konimex/neofetch/repo/epel-7/konimex-neofetch-epel-7.repo
yum install -y neofetch
neofetch
uname －a
cat /proc/version （Linux查看当前操作系统版本信息）
cat /etc/issue 
getconf LONG_BIT 
lsb_release -a 

#镜像源所在位置 /etc/yum.repos.d

# 网速测试
pip3 install speedtest_cli

# easy_install 安装
# easy_install speedtest_cli

speedtest #直接测试
speedtest --share #测试之后分享结果
speedtest --list  #列出当前所有的服务器测试点

# 网络测试
# fast test
curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast 

# curl -fsSL https://ilemonrain.com/download/shell/LemonBench.sh | bash -s fast
# wget -qO- https://ilemonrain.com/download/shell/LemonBench.sh | bash -s fast
# #complete test
# curl -fsSL https://ilemonrain.com/download/shell/LemonBench.sh | bash -s full
# wget -qO- https://ilemonrain.com/download/shell/LemonBench.sh | bash -s full

#firewall-cmd
yum install firewalld  #安装防火墙
systemctl mask service.name
systemctl unmask service.name
firewall-cmd --state #查看默认防火墙状态（关闭后显示notrunning，开启后显示running）
systemctl start firewalld.service #start/stop/restart/enable/disable/status
firewall-cmd --zone=public --add-port=8381/tcp --permanent  #开放8381端口
firewall-cmd --zone=public --remove-port=8381/tcp --permanent #删除8381端口
firewall-cmd --reload #重启firewall
firewall-cmd --list-ports #查看已经开放的端口

# service 上一代的系统服务控制
# systemctl 权限更高，相当于管理员
# chkconfig 权限仅仅相当于普通用户

# SSH远程连接
ssh -p 22 root@remoteserverip

#系统时间查看
# date [-s](date or time)
# clock --show//系统时钟查看

# Torrent Download
# tansmission
# 1.install epel-release sources
yum install epel-release
yum -y update
# 2.install tansmission
yum -y install transmission-cli transmission-common transmission-daemon
# 3.check status
systemctl start transmission-daemon.service
systemctl status transmission-daemon.service
# 4.config
systemctl stop transmission-daemon.service
vim /var/lib/transmission/.config/transmission-daemon/settings.json
  '
  "rpc-authentication-required": true,
  "rpc-enabled": true,
  "rpc-password": "password",
  "rpc-username": "username",
  "rpc-whitelist-enabled": false
  '
# 5.restart service
systemctl start transmission-daemon.service

# qBittorrent
# 1.install docker 
yum -y install docker
# 2.pull qbittorrent
# service docker start 
systemctl start docker
docker pull linuxserver/qbittorrent
# config
  "
  docker create \
    --name=qbittorrent \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Aisa/Shanghai \
    -e UMASK_SET=022 \
    -e WEBUI_PORT=6080 \
    -p 8999:8999 \
    -p 8999:8999/udp \
    -p 6080:6080 \
    -v /path/to/appdata/config:/config \
    -v /var/lib/transmission/Downloads:/downloads \
    --restart unless-stopped \
    linuxserver/qbittorrent
  "
# start qbittorrent
docker start qbittorrent

# 文件服务器
# 1.caddy
# 1.install
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh
# 2.config
echo ":80 {  
 root /path/to/downloads
 timeouts none  
 gzip  
 browse  
}" > /usr/local/caddy/Caddyfile
# 3.start
/etc/init.d/caddy start
# 4.port open
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
# last.access file by romote ip
# h5ai 需要docker环境
docker run -d -p 8055:80 -v /home/tr/download:/h5ai --name h5ai ilemonrain/h5ai:full -d

# github file
ssh-keygen -t rsa -C "personal@qq.com" #txt 打开.ssh/file.pub, past ssh in github account
ssh -T git@github.com
git config --global user.name "kuailei"
git config --global user.email "personal@qq.com"
git remote  add origin git@github.com:/educate.git
cd targetfile
git init
git add . or "*"#全部或是修改 1
git commit -m "注释" #2
git pull origin master --allow-unrelated-histories #消除文件差异
git push origin master #3

