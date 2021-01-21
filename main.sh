#/usr/bin/bash
#当前的md5获取方式不怎么牢靠，有待优化
echo ###############################################################
echo Openwrt firmware one-click update compilation script		   #
echo															   #
echo script By Lenyu										       #
echo 															   #
echo version v1.2.1											       #
echo #################################################################
sleep 3
clear
cd ~/
echo
##lede
git -C ~/lede pull >/dev/null 2>&1
git -C ~/lede rev-parse HEAD > new_lede
new_lede=`cat new_lede`
#判断old_lede是否存在，不存在创建
if [ ! -f "old_lede" ]; then
  clear
  echo "old_lede被删除正在创建！"
  sleep 0.1
  echo $new_lede > old_lede
fi
sleep 0.1
old_lede=`cat old_lede`
if [ "$new_lede" = "$old_lede" ]; then
	echo "no_update" > /home/lenyu/nolede
else
	echo "update" > /home/lenyu/nolede
	echo $new_lede > old_lede
fi
echo
##xray
if [ ! -d  "xray_update" ]; then
	echo "xray_update文件夹不存在，准备创建…"
	mkdir -p ~/xray_update
else
	count=`ls /home/lenyu/xray_update`
	if [ "$count" > "0" ]; then  #判断文件夹是否为0,否则git拉去xray源码
		git -C ~/xray_update pull >/dev/null 2>&1
		git -C ~/xray_update rev-parse HEAD > ~/new_xray
	else
		git clone https://github.com/XTLS/Xray-core.git ~/xray_update #后面指定目录
		git -C ~/xray_update pull >/dev/null 2>&1
		git -C ~/xray_update rev-parse HEAD > ~/new_xray
	fi
fi
echo
new_xray=`cat new_xray`
#判断old_xray是否存在，不存在创建
if [ ! -f "old_xray" ]; then
  clear
  echo "old_xray被删除正在创建！"
  sleep 0.1
  echo $new_xray > old_xray
fi
sleep 0.1
old_xray=`cat old_xray`
#有xray更新就替换最新的commit分支id
if [ "$new_xray" = "$old_xray" ]; then
	clear
	echo "no_update" > /home/lenyu/noxray
else
	clear
	echo "发现更新，准备切换到最新的commit分支MD5"
	echo "update" > /home/lenyu/noxray
	sleep 1
	#替换最新的md5值 sed要使用""才会应用变量
	sed -i "s/.*PKG_SOURCE_VERSION:.*/PKG_SOURCE_VERSION:=$new_xray/" /home/lenyu/lede/package/lean/xray/Makefile
	echo $new_xray > old_xray
fi
echo
##passwall
git -C ~/lede/feeds/passwall pull >/dev/null 2>&1
git -C ~/lede/feeds/passwall rev-parse HEAD > new_passw
new_passw=`cat new_passw`
#判断old_passw是否存在，不存在创建
if [ ! -f "old_passw" ]; then
  clear
  echo "old_passw被删除正在创建！"
  sleep 0.1
  echo $new_passw > old_passw
fi
sleep 0.1
old_passw=`cat old_passw`
if [ "$new_passw" = "$old_passw" ]; then
	echo "no_update" > /home/lenyu/nopassw
else
	echo "update" > /home/lenyu/nopassw
	echo $new_passw > old_passw
fi
echo
##ssr+
git -C ~/lede/feeds/helloworld pull >/dev/null 2>&1
git -C ~/lede/feeds/helloworld rev-parse HEAD > new_ssr
new_ssr=`cat new_ssr`
#判断old_ssr是否存在，不存在创建
if [ ! -f "old_ssr" ]; then
  clear
  echo "old_ssr被删除正在创建！"
  sleep 0.1
  echo $new_ssr > old_ssr
fi
sleep 0.1
old_ssr=`cat old_ssr`
if [ "$new_ssr" = "$old_ssr" ]; then
	echo "no_update" > /home/lenyu/nossr
else
	echo "update" > /home/lenyu/nossr
	echo $new_ssr > old_ssr
fi
echo
##openclash
git -C ~/lede/package/luci-app-openclash  pull >/dev/null 2>&1
git -C ~/lede/package/luci-app-openclash  rev-parse HEAD > new_clash
new_clash=`cat new_clash`
#判断old_clash是否存在，不存在创建
if [ ! -f "old_clash" ]; then
  clear
  echo "old_ssr被删除正在创建！"
  sleep 0.1
  echo $new_clash > old_clash
fi
sleep 0.1
old_clash=`cat old_clash`
if [ "$new_clash" = "$old_clash" ]; then
	echo "no_update" > /home/lenyu/noclash
else
	echo "update" > /home/lenyu/noclash
	echo $new_clash > old_clash
fi
echo



#总结判断之
nolede=`cat /home/lenyu/nolede`
noclash=`cat /home/lenyu/noclash`
noxray=`cat /home/lenyu/noxray`
nossr=`cat /home/lenyu/nossr`
nopassw=`cat /home/lenyu/nopassw`
sleep 0.5
if [[("$nolede" = "update") || ("$noclash" = "update") || ("$noxray" = "update") || ("$nossr" = "update" ) || ("$nopassw"  = "update" )]]; then
	clear
	echo
	echo "发现更新，请稍后…"
	clear
	echo
	echo "准备开始编译最新固件…"
	source /etc/environment && cd /home/lenyu/lede && ./scripts/feeds update -a  && ./scripts/feeds install -a && make defconfig && make -j8 download && make -j10 V=s &&  bash rename.sh
	echo
	rm -rf /home/lenyu/noxray
	rm -rf /home/lenyu/noclash
	rm -rf /home/lenyu/nolede
	rm -rf /home/lenyu/nossr
	rm -rf /home/lenyu/nopassw
	echo "固件编译成功，脚本退出！"
	echo
	exit 0
fi
echo
if [[("$nolede" = "no_update") && ("$noclash" = "no_update") && ("$noxray" = "no_update") && ("$nossr" = "no_update" ) && ("$nopassw"  = "no_update" )]]; then
	clear
	echo
	echo "呃呃…检查lede/ssr+/xray/passwall/openclash源码，没有一个源码更新哟…还是稍安勿躁…"
fi
#脚本结束，准备最后的清理工作
rm -rf /home/lenyu/noxray
rm -rf /home/lenyu/noclash
rm -rf /home/lenyu/nolede
rm -rf /home/lenyu/nossr
rm -rf /home/lenyu/nopassw
echo
echo "脚本退出！"
echo
exit 1