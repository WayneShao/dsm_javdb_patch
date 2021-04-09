#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

# VAR   ******************************************************************
vVersion='1.6';
vAction=$1;
# Logo  ******************************************************************
CopyrightLogo="
                DS Video JavBus+JavDB+Douban 搜刮器补丁 $vVersion  QQ 群:160128165                                             
                                                                            
==========================================================================";
echo "$CopyrightLogo";
# Function List *******************************************************************************
function install()
{
    cd /tmp/;
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O - | python && easy_install pip && pip install requests && pip install bs4 && pip install lxml

    mv /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback
    mv /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php.javback
    mv /var/packages/VideoStation/target/ui/videostation2.js /var/packages/VideoStation/target/ui/videostation2.js.javback

    wget --no-check-certificate https://gitee.com/siryle1213/dsm_javdb_patch/raw/master/dsm_javbus_douban_patch.tar -O dsm_javbus_douban_patch.tar;
    tar -xvf dsm_javbus_douban_patch.tar

    cp -rfa ./dsm_javbus_douban_patch/syno_themoviedb /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_javbus_douban_patch/ui /var/packages/VideoStation/target/;
    cp -rfa ./dsm_javbus_douban_patch/syno_themoviedb_tv /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_javbus_douban_patch/syno_file_assets /var/packages/VideoStation/target/plugins/;

    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/javdblist.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/javdbdata.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/ui/videostation2.js
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/ui/videostation2.js
    cd -
    rm -rf dsm_javbus_douban_patch.sh
    echo '==========================================================================';
    echo "恭喜, DS Video JavBus+JavDB+Douban 搜刮器补丁 $vVersion 安装完成！";
    echo '==========================================================================';
}
function upgrade()
{
    cd /tmp/;

    wget --no-check-certificate https://gitee.com/siryle1213/dsm_javdb_patch/raw/master/dsm_javbus_douban_patch.tar -O dsm_javbus_douban_patch.tar;
    tar -xvf dsm_javbus_douban_patch.tar

    cp -rfa ./dsm_javbus_douban_patch/syno_themoviedb /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_javbus_douban_patch/ui /var/packages/VideoStation/target/;
    cp -rfa ./dsm_javbus_douban_patch/syno_themoviedb_tv /var/packages/VideoStation/target/plugins/;
    cp -rfa ./dsm_javbus_douban_patch/syno_file_assets /var/packages/VideoStation/target/plugins/;

    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/javdblist.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/javdbdata.py
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/ui/videostation2.js
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/ui/videostation2.js
    cd -
    rm -rf dsm_javbus_douban_patch.sh
    echo '==========================================================================';
    echo "恭喜, DS Video JavBus+JavDB+Douban 搜刮器补丁 $vVersion 更新完成！";
    echo '==========================================================================';
}
function uninstall()
{   
    rm /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
    rm /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
    rm /var/packages/VideoStation/target/plugins/syno_themoviedb/javdblist.py
    rm /var/packages/VideoStation/target/plugins/syno_themoviedb/javdbdata.py
    rm /var/packages/VideoStation/target/plugins/syno_file_assets/douban.php
    
    mv -f /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    mv -f /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php.javback /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    mv -f /var/packages/VideoStation/target/ui/videostation2.js.javback /var/packages/VideoStation/target/ui/videostation2.js
    
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chmod 0755 /var/packages/VideoStation/target/ui/videostation2.js

    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb_tv/search.php
    chown VideoStation:VideoStation /var/packages/VideoStation/target/ui/videostation2.js
    
    
    echo 'DS Video JavBus+JavDB+Douban 搜刮器补丁 卸载完成！ QQ 群:160128165';
    echo '==========================================================================';
}

# SHELL     ******************************************************************
if [ "$vAction" == 'install' ]; then
    if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
        install;
    else
        echo '你已经安装过 DS Video JavBus 或 JavDB 或 JavBus+JavDB+Douban 搜刮器补丁. QQ 群:160128165';
        echo '==========================================================================';
        rm -rf dsm_javbus_douban_patch.sh
        exit 1;
    fi;
elif [ "$vAction" == 'upgrade' ]; then
    if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
        echo '你还没安装过 DS Video JavBus+JavDB+Douban 搜刮器补丁，无法更新. QQ 群:160128165';
        echo '==========================================================================';
        rm -rf dsm_javbus_douban_patch.sh
        exit 1;
    else
        upgrade;
    fi;
elif [ "$vAction" == 'uninstall' ]; then
    if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
        echo '你还没安装过 DS Video JavBus+JavDB+Douban 搜刮器补丁，无需卸载. QQ 群:160128165';
        echo '==========================================================================';
        rm -rf dsm_javbus_douban_patch.sh
        exit 1;
    else
        uninstall;
    fi;
else
    echo '错误的命令';
    echo '==========================================================================';
    rm -rf dsm_javbus_douban_patch.sh
    exit 1
fi;
