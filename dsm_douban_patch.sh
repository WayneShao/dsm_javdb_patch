#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

# VAR   ******************************************************************
vVersion='1.7';
vAction=$1;
# Logo  ******************************************************************
CopyrightLogo="
                DS Video Douban 搜刮器补丁 $vVersion  QQ 群:160128165                                             
                                                                            
==========================================================================";
echo "$CopyrightLogo";
# Function List *******************************************************************************
function install()
{
    cd /tmp/;

    wget --no-check-certificate https://gitee.com/siryle1213/dsm_javdb_patch/raw/master/dsm_douban_patch.tar -O dsm_douban_patch.tar;
    tar -xvf dsm_douban_patch.tar

    cp -rfa ./dsm_douban_patch/syno_themoviedb /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_douban_patch/syno_themoviedb_tv /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_douban_patch/syno_file_assets /var/packages/VideoStation/target/plugins/;

    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php

    cd -
    rm -rf dsm_douban_patch.sh
    echo '==========================================================================';
    echo "恭喜, DS Video Douban 搜刮器补丁 $vVersion 安装完成！";
    echo '==========================================================================';
}
# SHELL     ******************************************************************
if [ "$vAction" == 'install' ]; then
    install;
else
    echo '错误的命令';
    echo '==========================================================================';
    rm -rf dsm_douban_patch.sh
    exit 1
fi;
