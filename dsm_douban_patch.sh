#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

# VAR   ******************************************************************
vVersion='1.6';
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

    mv /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.doubanback
    mv /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php.doubanback
    mv /var/packages/VideoStation/target/ui/videostation2.js /var/packages/VideoStation/target/ui/videostation2.js.doubanback

    wget --no-check-certificate https://gitee.com/siryle1213/dsm_javdb_patch/raw/master/dsm_douban_patch.tar -O dsm_douban_patch.tar;
    tar -xvf dsm_douban_patch.tar

    cp -rfa ./dsm_douban_patch/syno_themoviedb /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_douban_patch/ui /var/packages/VideoStation/target/;
    cp -rfa ./dsm_douban_patch/syno_themoviedb_tv /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_douban_patch/syno_file_assets /var/packages/VideoStation/target/plugins/;

    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/ui/videostation2.js
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/ui/videostation2.js
    cd -
    rm -rf dsm_douban_patch.sh
    echo '==========================================================================';
    echo "恭喜, DS Video Douban 搜刮器补丁 $vVersion 安装完成！";
    echo '==========================================================================';
}
function uninstall()
{   
    rm /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php
    
    mv -f /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.doubanback /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    mv -f /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php.doubanback /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    mv -f /var/packages/VideoStation/target/ui/videostation2.js.doubanback /var/packages/VideoStation/target/ui/videostation2.js
    
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/ui/videostation2.js

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/ui/videostation2.js
    
    
    echo 'DS Video Douban 搜刮器补丁 卸载完成！ QQ 群:160128165';
    echo '==========================================================================';
}

# SHELL     ******************************************************************
if [ "$vAction" == 'install' ]; then
    if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.doubanback" ]; then
        install;
    else
        echo '你已经安装过 DS Video JavBus 或 JavDB 或 JavBus+JavDB+Douban 搜刮器补丁. QQ 群:160128165';
        echo '==========================================================================';
        rm -rf dsm_douban_patch.sh
        exit 1;
    fi;
elif [ "$vAction" == 'uninstall' ]; then
    if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.doubanback" ]; then
        echo '你还没安装过 DS Video JavBus+JavDB+Douban 搜刮器补丁，无需卸载. QQ 群:160128165';
        echo '==========================================================================';
        rm -rf dsm_douban_patch.sh
        exit 1;
    else
        uninstall;
    fi;
else
    echo '错误的命令';
    echo '==========================================================================';
    rm -rf dsm_douban_patch.sh
    exit 1
fi;
