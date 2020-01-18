感谢 SaNy [他的Coding主页](https://coding.net/u/sanylee/p/self/git "SaNy")，有需要豆瓣刮削器的可以前往查看

安装教程
注意：文件名必须是完整番号（xxx-001或xxx001），后面可以带“C”或“-C”,否则可能会搜刮不到。
1.DSM首先要开启SSH功能：控制面板-终端机和SNMP-启动SSH功能打钩
2.使用SSH工具连接DSM，win10系统可以直接在cmd里输入ssh admin@群辉的IP地址，按回车然后输入你的登录密码（注意输入密码的时候不会显示出来，完整输入之后按回车就行了）
3.登录成功后，输入sudo -i 按回车，再输入一次你的admin登录密码，切换到root模式 。
4.输入 wget https://gitee.com/challengerV/dsm_javdb_patch/raw/master/dsm_javdb_patch.sh &&sh dsm_javdb_patch.sh install ，等待安装完成（如需卸载，把最后的install 换成uninstall）
5.点击右上角设置-视频库-编辑文件夹，或者新建一个视频文件夹，将小姐姐文件夹的启用视频信息搜索功能打开，语言选择“日本语”（只有设置成日本语，才会走小姐姐刮削器，不要设置错了）
6.设置完成后，Video Station会自动进行索引，小姐姐的封面很快就会显示出来了。如果没有自动索引的话，尝试关掉视频信息搜索再打开。
7.视频文件名请尽量只保留番号，否则可能查询不到
8.无法自动搜刮的视频，可以点击“编辑视频信息”，进行手动搜索