#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

clear;

# VAR 	******************************************************************
vVersion='local python';
vAction=$1;
# Logo 	******************************************************************
CopyrightLogo="
                DS Video JavDB Patch $vVersion                                                 
                                                                            
==========================================================================";
echo "$CopyrightLogo";

# Function List	*******************************************************************************
function install()
{
	cd /tmp/;
	wget https://bootstrap.pypa.io/ez_setup.py -O - | python && easy_install pip && pip install requests && pip install bs4 && pip install lxml
	
	mv /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback
	mv /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php.javback
	mv /var/packages/VideoStation/target/ui/videostation2.js /var/packages/VideoStation/target/ui/videostation2.js.javback

	wget --no-check-certificate https://gitee.com/challengerV/dsm_javdb_patch/raw/master/dsm_javdb_patch.tar -O dsm_javdb_patch.tar;
	tar -xvf dsm_javdb_patch.tar

	\cp -rfa ./syno_themoviedb /var/packages/VideoStation/target/plugins/;
	\cp -rfa ./syno_synovideodb /var/packages/VideoStation/target/plugins/;

	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/list.py
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_themoviedb/data.py
	chmod 0755 /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php

	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_themoviedb/search.php
	chown VideoStation:VideoStation /var/packages/VideoStation/target/plugins/syno_synovideodb/search.php

	echo '==========================================================================';
	echo "Congratulations, DS Video JavDB Patch $vVersion install completed.";
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
	
	
	echo 'Congratulations, DS Video JavDB Patch uninstall completed.';
	echo '==========================================================================';
}

# SHELL 	******************************************************************
if [ "$vAction" == 'install' ]; then
	if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
		install;
	else
		echo 'Sorry, you have already installed DS Video JavDB Patch.';
		echo '==========================================================================';
		exit 1;
	fi;
elif [ "$vAction" == 'uninstall' ]; then
	if [ ! -f "/var/packages/VideoStation/target/plugins/syno_themoviedb/search.php.javback" ]; then
		echo 'Sorry, you have not installed DS Video JavDB Patch yet.';
		echo '==========================================================================';
		exit 1;
	else
		uninstall;
	fi;
else
	echo 'Sorry, Failed to install DS Video JavDB Patch.';
	echo '==========================================================================';
	exit 1
fi;
