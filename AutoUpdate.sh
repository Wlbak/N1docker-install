#/bin/bash

TIME() {
[[ -z "$1" ]] && {
	echo -ne " "
} || {
     case $1 in
	r) export Color="\e[31;1m";;
	g) export Color="\e[32;1m";;
	b) export Color="\e[34;1m";;
	y) export Color="\e[33;0m";;
	z) export Color="\e[35;1m";;
	l) export Color="\e[36;1m";;
      esac
	[[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
		echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
	 }
      }
}

while :; do
echo
TIME g "------- gd772 N1固件 在线更新 菜单 --------"
echo
TIME g "[1] 更新至 2022.03.23 编译的 R22.2.2_5.10.103"
echo
TIME r "[0] 说啥也不好使了，继续做【钉子户】退出更新"
echo
read -p " 输入 序号 然后 敲回车确认 请输入您的选择： " CHOOSE
case $CHOOSE in
1)
echo
TIME g "【2022.04.23 更新日志】"
TIME g "1.原有的 Passwall 更换为 Passwall2 "
TIME g "2.阿里云盘 aliyundrive-fuse 更换为 aliyundrive-webdav "
TIME g "3.原有的 uHttpd 更换为 Nginx 方便反代折腾 "
TIME g "4.添加 软件源 固件编译成功时 生成的软件 无需科学环境 "
TIME g "5.OpenClash 默认预加载 Clash内核 无科学环境下 直接添加配置后使用 "
cd /mnt/mmcblk2p4
rm -rf *.sh Phicomm-N1_*
url=http://119.29.111.152:10086/d/aliDrive/update/2022.04.23
Firmware=Phicomm-N1_OP-R22.4.1_5.10.112.tar.gz
if [ -f "/etc/update.sh" ]; then
cp -r /etc/update.sh /mnt/mmcblk2p4                        #升级脚本 存在 则复制到mmcblk2p4录目
else                                                       #升级脚本 不存在 则下载到mmcblk2p4目录
cd /mnt/mmcblk2p4
curl -LO http://119.29.111.152:10086/d/aliDrive/update/update.sh
fi
if [ -f "/etc/flippy-openwrt-release" ]; then              #判断 flippy-openwrt-release 文件是否存在
mv -f /etc/flippy-openwrt-release /etc/openwrt-release     #存在 则改名为 openwrt-release
sed -i 's/s905d/Phicomm/g' /etc/openwrt-release            #修改 SOC
sed -i 's/n1/N1/g' /etc/openwrt-release                    #修改 BOARD
fi   
echo
TIME g "================================ 下载固件中 =================================="
curl -LO $url/$Firmware
TIME g "===============================下载完成,解压中==============================="
tar -zxvf *tar.gz && rm -f *.tar.gz
TIME r "============================解压完成,开始升级固件============================"
chmod 755 update.sh
bash update.sh *.img
break
;;
0)
echo
TIME r "您选择了 [0] 继续做【钉子户】退出本次更新"
echo
exit 0
break
;;
*)
echo
TIME r "请输入正确的序号!"
;;
esac
done
