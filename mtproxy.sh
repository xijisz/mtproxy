#!/bin/bash
WORKDIR=$(dirname $(readlink -f $0))
cd $WORKDIR
pid_file=$WORKDIR/pid/pid_mtproxy

check_sys() {
    local checkType=$1
    local value=$2

    local release=''
    local systemPackage=''

    if [[ -f /etc/redhat-release ]]; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /etc/issue; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /etc/issue; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /etc/issue; then
        release="centos"
        systemPackage="yum"
    elif grep -Eqi "debian|raspbian" /proc/version; then
        release="debian"
        systemPackage="apt"
    elif grep -Eqi "ubuntu" /proc/version; then
        release="ubuntu"
        systemPackage="apt"
    elif grep -Eqi "centos|red hat|redhat" /proc/version; then
        release="centos"
        systemPackage="yum"
    fi

    if [[ "${checkType}" == "sysRelease" ]]; then
        if [ "${value}" == "${release}" ]; then
            return 0
        else
            return 1
        fi
    elif [[ "${checkType}" == "packageManager" ]]; then
        if [ "${value}" == "${systemPackage}" ]; then
            return 0
        else
            return 1
        fi
    fi
}


function is_installed() {
    if [ ! -f "$WORKDIR/mtp_config" ]; then
        return 1
    fi
    return 0
}


param=$1


if [[ "start" == $param ]]; then
    echo "即将：启动脚本"
    run_mtp
elif [[ "daemon" == $param ]]; then
    echo "即将：启动脚本(守护进程)"
    daemon_mtp
elif [[ "stop" == $param ]]; then
    echo "即将：停止脚本"
    stop_mtp
elif [[ "debug" == $param ]]; then
    echo "即将：调试运行"
    debug_mtp
elif [[ "restart" == $param ]]; then
    stop_mtp
    run_mtp
    debug_mtp
elif [[ "reinstall" == $param ]]; then
    reinstall_mtp
elif [[ "build" == $param ]]; then
    arch=$(get_architecture)
    if [[ "$arch" == "amd64" ]]; then
        build_mtproto 1
    fi
     build_mtproto 2
else
    if ! is_installed; then
        echo "MTProxyTLS一键安装运行绿色脚本"
        print_line
        echo -e "检测到您的配置文件不存在, 为您指引生成!" && print_line

        do_install_basic_dep
        do_config_mtp
        do_install
        run_mtp
    else
        [ ! -f "$WORKDIR/mtp_config" ] && do_config_mtp
        echo "MTProxyTLS一键安装运行绿色脚本"
        print_line
        info_mtp
        print_line
        echo -e "脚本源码：https://github.com/ellermister/mtproxy"
        echo -e "配置文件: $WORKDIR/mtp_config"
        echo -e "卸载方式：直接删除当前目录下文件即可"
        echo "使用方式:"
        echo -e "\t启动服务\t bash $0 start"
        echo -e "\t调试运行\t bash $0 debug"
        echo -e "\t停止服务\t bash $0 stop"
        echo -e "\t重启服务\t bash $0 restart"
        echo -e "\t重新安装代理程序 bash $0 reinstall"
    fi
fi


