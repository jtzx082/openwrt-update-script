#usr/bin/bash
#当前的md5获取方式不怎么牢靠，有待优化
echo ###############################################################
echo Openwrt firmware one-click update compilation script		   #
echo															   #
echo script By Lenyu										       #
echo 															   #
echo version v1.3.2											       #
echo #################################################################
sleep 3
#获取当前脚本所在的目录
path=$(dirname $(readlink -f $0))
#调用
cd ${path}
echo
##lede
git -C ${path}/lede pull >/dev/null 2>&1
git -C ${path}/lede rev-parse HEAD > new_lede
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
	echo "no_update" > ${path}/nolede
else
	echo "update" > ${path}/nolede
	echo $new_lede > old_lede
fi
echo
##xray
if [ ! -d  "xray_update" ]; then
	echo "xray_update文件夹不存在，准备创建…"
	mkdir -p ${path}/xray_update
else
	count=`ls ${path}/xray_update`
	if [ "$count" > "0" ]; then  #判断文件夹是否为0,否则git拉去xray源码
		git -C ${path}/xray_update pull >/dev/null 2>&1
		git -C ${path}/xray_update rev-parse HEAD > ${path}/new_xray
	else
		git clone https://github.com/XTLS/Xray-core.git ${path}/xray_update #后面指定目录
		git -C ${path}/xray_update pull >/dev/null 2>&1
		git -C ${path}/xray_update rev-parse HEAD > ${path}/new_xray
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
	echo "no_update" > ${path}/noxray
else
	clear
	echo "发现更新，准备切换到最新的commit分支MD5"
	echo "update" > ${path}/noxray
	sleep 1
	#替换最新的md5值 sed要使用""才会应用变量
	sed -i "s/.*PKG_SOURCE_VERSION:.*/PKG_SOURCE_VERSION:=$new_xray/" ${path}/lede/package/lean/xray/Makefile
	echo $new_xray > old_xray
fi
echo
##passwall
git -C ${path}/lede/feeds/passwall pull >/dev/null 2>&1
git -C ${path}/lede/feeds/passwall rev-parse HEAD > new_passw
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
	echo "no_update" > ${path}/nopassw
else
	echo "update" > ${path}/nopassw
	echo $new_passw > old_passw
fi
echo
##ssr+
git -C ${path}/lede/feeds/helloworld pull >/dev/null 2>&1
git -C ${path}/lede/feeds/helloworld rev-parse HEAD > new_ssr
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
	echo "no_update" > ${path}/nossr
else
	echo "update" > ${path}/nossr
	echo $new_ssr > old_ssr
fi
echo
##openclash
git -C ${path}/lede/package/luci-app-openclash  pull >/dev/null 2>&1
git -C ${path}/lede/package/luci-app-openclash  rev-parse HEAD > new_clash
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
	echo "no_update" > ${path}/noclash
else
	echo "update" > ${path}/noclash
	echo $new_clash > old_clash
fi
echo
echo 脚本正在运行中…
#总结判断之
#监测如果不存在rename.sh则创建该文件
if [ ! -f "${path}/lede/rename.sh" ]; then
 echo "rename.sh被删除,正在创建！"
cat>${path}/lede/rename.sh<<EOF
#/usr/bin/bash
path=\$(dirname \$(readlink -f \$0))
cd \${path}
		rm -rf \${path}/bin/targets/x86/64/*Lenyu.img.gz
        rm -rf \${path}/bin/targets/x86/64/packages
        rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic.manifest
        rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-rootfs-squashfs.img.gz
        rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-combined-squashfs.vmdk
        rm -rf \${path}/bin/targets/x86/64/config.seed
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-uefi-gpt-squashfs.vmdk
        rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-vmlinuz
		rm -rf \${path}/bin/targets/x86/64/sha256sums
		rm -rf \${path}/bin/targets/x86/64/config.buildinfo
		rm -rf \${path}/bin/targets/x86/64/feeds.buildinfo
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-kernel.bin
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.vmdk
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.vmdk
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-rootfs.img.gz
		rm -rf \${path}/bin/targets/x86/64/version.buildinfo
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img
		rm -rf \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-rootfs.img
        sleep 3
        stre=\`sed '11!d'  \${path}/include/kernel-version.mk\` >nul 2>nul
        sleep 2
        mv \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz      \${path}/bin/targets/x86/64/openwrt_x86-64-\`date '+%m%d'\`_5.4.\`echo \${stre#* .}\`_dev_Lenyu.img.gz
        mv \${path}/bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.img.gz  \${path}/bin/targets/x86/64/openwrt_x86-64-\`date '+%m%d'\`_5.4.\`echo \${stre#* .}\`_uefi-gpt_dev_Lenyu.img.gz
		exit 0
EOF
fi
sleep 0.2
nolede=`cat ${path}/nolede`
noclash=`cat ${path}/noclash`
noxray=`cat ${path}/noxray`
nossr=`cat ${path}/nossr`
nopassw=`cat ${path}/nopassw`
sleep 0.5
if [[("$nolede" = "update") || ("$noclash" = "update") || ("$noxray" = "update") || ("$nossr" = "update" ) || ("$nopassw"  = "update" )]]; then
	clear
	echo
	echo "发现更新，请稍后…"
	clear
	echo
	echo "准备开始编译最新固件…"
	source /etc/environment && cd ${path}/lede && ./scripts/feeds update -a  && ./scripts/feeds install -a && make defconfig && make -j8 download && make -j10 V=s &&  bash rename.sh
	echo
	rm -rf ${path}/noxray
	rm -rf ${path}/noclash
	rm -rf ${path}/nolede
	rm -rf ${path}/nossr
	rm -rf ${path}/nopassw
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
rm -rf ${path}/noxray
rm -rf ${path}/noclash
rm -rf ${path}/nolede
rm -rf ${path}/nossr
rm -rf ${path}/nopassw
echo
echo "脚本退出！"
echo
exit 1
