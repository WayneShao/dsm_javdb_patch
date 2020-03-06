#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

# VAR 	******************************************************************
vVersion='1.0';
vAction=$1;
# Logo 	******************************************************************
CopyrightLogo="
                DS Video JavBus 搜刮器补丁 $vVersion  QQ 群:160128165                                             
                                                                            
==========================================================================";
echo "$CopyrightLogo";
function python_model_check()
{
  if python -c "import $1" >/dev/null 2>&1
  then
      echo "1"
  else
      echo "0"
  fi
}
# Function List	*******************************************************************************
function install()
{
	cd /tmp/;
	wget https://bootstrap.pypa.io/ez_setup.py -O - | python && easy_install pip && pip install requests && pip install bs4 && pip install lxml

	mv /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback
	mv /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php.javback

	wget --no-check-certificate https://gitee.com/challengerV/dsm_javdb_patch/raw/master/dsm_javbus_patch.tar -O dsm_javbus_patch.tar;
	tar -xvf dsm_javbus_patch.tar

	cp -rfa ./dsm_javbus_patch/syno_themoviedb /var/packages/VideoStation/target/plugins/;
	cp -rfa ./dsm_javbus_patch/syno_synovideodb /var/packages/VideoStation/target/plugins/;

	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php

	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php
	cd -
	rm -rf dsm_javbus_patch.sh
	echo '==========================================================================';
	echo "恭喜, DS Video JavBus 补丁 $vVersion 安装完成！";
	echo '==========================================================================';
}

function uninstall()
{	
	rm /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
	rm /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
	
	mv -f /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	mv -f /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php.javback /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php
	
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php

	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php
	
	
	echo 'DS Video JavBus Patch 卸载完成！ QQ 群:160128165';
	echo '==========================================================================';
}

# SHELL 	******************************************************************
if [ "$vAction" == 'install' ]; then
	if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
		install;
	else
		echo '你已经安装过 DS Video JavBus 或 JavDB 补丁. QQ 群:160128165';
		echo '==========================================================================';
		rm -rf dsm_javbus_patch.sh
		exit 1;
	fi;
elif [ "$vAction" == 'uninstall' ]; then
	if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
		echo '你还没用安装过 installed DS Video JavBus 补丁，无需卸载. QQ 群:160128165';
		echo '==========================================================================';
		rm -rf dsm_javbus_patch.sh
		exit 1;
	else
		uninstall;
	fi;
else
	echo '错误的命令';
	echo '==========================================================================';
	rm -rf dsm_javbus_patch.sh
	exit 1
fi;
