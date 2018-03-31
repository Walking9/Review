#!/bin/bash
#该脚本适合在centos, debian, ubuntu上装vps的bbr加速
#author: Walking9

echo "****************欢迎使用bbr一键加速脚本*****************"
echo "当前EUID：$EUID"
if [ $EUID -eq 0 ]    #判断是否为root权限, 0--是
# 用RUID, EUID,SUID来表示实际用户ID，有效用户ID，设置用户ID
# RUID, 用于在系统中标识一个用户是谁，当用户使用用户名和密码成功登录后一个UNIX系统后就唯一确定了他的RUID.
# EUID, 用于系统决定用户对系统资源的访问权限，通常情况下等于RUID。
# SUID，用于对外权限的开放。跟RUID及EUID是用一个用户绑定不同，它是跟文件而不是跟用户绑定。
then
	echo "start..."
else
	echo "请用root权限运行该脚本"
	exit 1
fi

if [ -d "/proc/vz" ]   #通过判断是否存在该目录来确定Linux 是否运行在虚拟机上
then
	echo "sorry, 暂不支持运行在虚拟机上的linux系统"
	exit 1
fi

# 备注：可以用 && 来代替这样的if： if 1 ; then exit 1注意理解为什么

echo "1. 请选择你的VPS操作系统：（1-centos, 2-debian, 3-ubuntu）:"  #其实也可以通过系统文件来判断
read choose
case $choose in
	1) release='centos';;    #双分号结尾
	2) release='debian';;
	3) release='ubuntu';;
	*) echo 'Error, exit'; exit 1;;
esac
echo "OS: ${release}"

get_opsy() {    # 获得系统版本信息
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

get_char() {
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}

getversion() {
    if [[ -s /etc/redhat-release ]]; then
        grep -oE  "[0-9.]+" /etc/redhat-release
    else
        grep -oE  "[0-9.]+" /etc/issue
    fi
}


centosversion() {
    if [ x"${release}" == x"centos" ]; then
        local code=$1
        local version="$(getversion)"
        local main_ver=${version%%.*}
        if [ "$main_ver" == "$code" ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

check_bbr_status() {
	# local一般用于局部变量声明，多在在函数内部使用。
    local param=$(sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}')
    if [ x"${param}" == x"bbr" ]; then
        return 0
    else
        return 1
    fi
}

version_ge(){
    test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"
}

check_kernel_version() {
    local kernel_version=$(uname -r | cut -d- -f1)
    if version_ge ${kernel_version} 4.9; then
        return 0
    else
        return 1
    fi
}

install_elrepo() {

    if centosversion 5; then
        echo -e "${red}Error:${plain} not supported CentOS 5."
        exit 1
    fi

    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

    if centosversion 6; then
        rpm -Uvh http://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
    elif centosversion 7; then
        rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
    fi

    if [ ! -f /etc/yum.repos.d/elrepo.repo ]; then
        echo -e "${red}Error:${plain} Install elrepo failed, please check it."
        exit 1
    fi
}

sysctl_config() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}

install_config() {
    if [[ x"${release}" == x"centos" ]]; then
        if centosversion 6; then
            if [ ! -f "/boot/grub/grub.conf" ]; then
                echo -e "${red}Error:${plain} /boot/grub/grub.conf not found, please check it."
                exit 1
            fi
            sed -i 's/^default=.*/default=0/g' /boot/grub/grub.conf
        elif centosversion 7; then
            if [ ! -f "/boot/grub2/grub.cfg" ]; then
                echo -e "${red}Error:${plain} /boot/grub2/grub.cfg not found, please check it."
                exit 1
            fi
            grub2-set-default 0
        fi
    elif [[ x"${release}" == x"debian" || x"${release}" == x"ubuntu" ]]; then
        /usr/sbin/update-grub
    fi
}

reboot_os() {
    echo
    echo -e "${green}Info:${plain} The system needs to reboot."
    read -p "Do you want to restart system? [y/n]" is_reboot
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        reboot
    else
        echo -e "${green}Info:${plain} Reboot has been canceled..."
        exit 0
    fi
}

install_bbr() {
    check_bbr_status
    if [ $? -eq 0 ]; then
        echo
        echo -e "${green}Info:${plain} TCP BBR has been installed. nothing to do..."
        exit 0
    fi
    check_kernel_version
    if [ $? -eq 0 ]; then
        echo
        echo -e "${green}Info:${plain} Your kernel version is greater than 4.9, directly setting TCP BBR..."
        sysctl_config
        echo -e "${green}Info:${plain} Setting TCP BBR completed..."
        exit 0
    fi

    if [[ x"${release}" == x"centos" ]]; then
        install_elrepo
        yum --enablerepo=elrepo-kernel -y install kernel-ml kernel-ml-devel
        if [ $? -ne 0 ]; then
            echo -e "${red}Error:${plain} Install latest kernel failed, please check it."
            exit 1
        fi
    elif [[ x"${release}" == x"debian" || x"${release}" == x"ubuntu" ]]; then
        [[ ! -e "/usr/bin/wget" ]] && apt-get -y update && apt-get -y install wget
        get_latest_version
        [ $? -ne 0 ] && echo -e "${red}Error:${plain} Get latest kernel version failed." && exit 1
        wget -c -t3 -T60 -O ${deb_kernel_name} ${deb_kernel_url}
        if [ $? -ne 0 ]; then
            echo -e "${red}Error:${plain} Download ${deb_kernel_name} failed, please check it."
            exit 1
        fi
        dpkg -i ${deb_kernel_name}
        rm -fv ${deb_kernel_name}
    else
        echo -e "${red}Error:${plain} OS is not be supported, please change to CentOS/Debian/Ubuntu and try again."
        exit 1
    fi

    install_config
    sysctl_config
    reboot_os
}

latest_version=$(wget -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/ | awk -F'\"v' '/v[4-9]./{print $2}' | cut -d/ -f1 | grep -v -  | sort -V | tail -1)  #查看最新版本包名
[ -z ${latest_version} ] && return 1
if [[ `getconf WORD_BIT` == "32" && `getconf LONG_BIT` == "64" ]]; then    #给32/64位VPS选择合适的安装包
    deb_name=$(wget -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${latest_version}/ | grep "linux-image" | grep "generic" | awk -F'\">' '/amd64.deb/{print $2}' | cut -d'<' -f1 | head -1)
    deb_kernel_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${latest_version}/${deb_name}"
    deb_kernel_name="linux-image-${latest_version}-amd64.deb"
else
    deb_name=$(wget -qO- http://kernel.ubuntu.com/~kernel-ppa/mainline/v${latest_version}/ | grep "linux-image" | grep "generic" | awk -F'\">' '/i386.deb/{print $2}' | cut -d'<' -f1 | head -1)
    deb_kernel_url="http://kernel.ubuntu.com/~kernel-ppa/mainline/v${latest_version}/${deb_name}"
    deb_kernel_name="linux-image-${latest_version}-i386.deb"
fi

opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
echo "---------- System Information ----------"
echo " OS      : $opsy"   # 操作系统版本
echo " Arch    : $arch ($lbit Bit)"  # 操作系统位数
echo " Kernel  : $kern"   # 内核版本
echo "----------------------------------------"
echo " Auto install latest kernel for TCP BBR"
echo "----------------------------------------"

# install_bbr 2>&1 | tee ${cur_dir}/install_bbr.log
