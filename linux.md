# 资源

| 网站               | 网址                            |
| ------------------ | ------------------------------- |
| 内核官网           | https://kernel.org/             |
| uboot 官网         | https://www.denx.de/wiki/U-Boot |
| Uboot ftp 下载地址 | https://ftp.denx.de/pub/u-boot/ |
| 嵌入式 Linux WiKi  | https://elinux.org/Main_Page    |
| Buildroot          | https://buildroot.org/          |
| 交叉打包工具       | https://crosstool-ng.github.io/ |

# Debian 12 bookorm 镜像源

可能 https 存在认证问题 先将源中的 https 改为 http，安装如下软件后再改回来
`sudo apt install apt-transport-https ca-certificates`

```bash

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

```

# 软件列表

```bash
# 必装软件

sudo apt install  build-essential vim git wget tldr unzip zip aptitude
# document
sudo apt install texlive-full emacs pandoc
# font
sudo apt install fonts-wqy-microhei fonts-wqy-zenhei
# python3 and pip
sudo apt install python-is-python3 python3-pip
# juypter
sudo apt install python3-ipykernel
# 小工具
sudo apt install ascii
```

# 常用命令

```bash
# 开机启动命令行界面
sudo systemctl set-default multi-user.target
# 开机启动图形化界面
sudo systemctl set-default graphical.target
# 查看所有中文字体
fc-list :lang=zh

# 当脚本中需要root密码 " "
# echo " " | sudo -S <cmd_xxxx>

# 桌面安装
sudo apt-get install gnome-shell ubuntu-gnome-desktop unity-tweak-tool gnome-tweak-tool
# 编译环境配置
sudo apt install cmake build-essential python-is-python3
# 压缩解压
tar -cvf demo.tar
tar -zcvf demo.tar.gz
tar -jcvf demo.tar.bz2
tar -xvf demo.tar
tar -jxvf demo.tar.bz2
tar -zxvf demo.tar.gz
```

# FAQ

| Q          | A                                                                        |
| ---------- | ------------------------------------------------------------------------ |
| 修改时区？ | `tzselect`设置,`ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime` |
|            |                                                                          |
|            |                                                                          |
|            |                                                                          |

Q: Linux 免登录?
A:

```bash
mkdir .ssh
mv id_rsa.pub .ssh
cd .ssh
cat id_rsa.pub >> authorized_keys
sudo chmod 600 authorized_keys
service sshd restart
```
