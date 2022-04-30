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
TIME g "--- gd772 N1固件 Docker相关 安装菜单 ---"
echo
TIME g "[1] 安装 Docker 及 DockerMan "
echo   ------------------------------
TIME g "[2] 安装 青龙面板 主路由模式"
echo   ------------------------------
TIME g "[3] 安装 青龙面板 旁路由模式"
echo   ------------------------------
TIME g "[4] 安装 elecV2P面板 主路由模式"
echo   ----------------------------------
TIME g "[5] 安装 elecV2P面板 旁路由模式"
echo   ----------------------------------
TIME r "[0] 退出 Docker相关 安装菜单"
echo -------------------
read -p " 请输入 序号 然后 敲回车确认: " CHOOSE
case $CHOOSE in
1)
echo
TIME g "[1] 安装 Docker 及 DockerMan 到固件"
cd /mnt/mmcblk2p4
url=https://raw.githubusercontent.com/Wlbak/N1docker-install/main
files=docker_20.10.12-2_N1.tar.gz
echo
TIME g "============================== 下载 Docker ================================="
curl -LO $url/$files
TIME g "=================================下载完成,解压中============================="
tar -zxvf *tar.gz && rm -f *.tar.gz
TIME g "============================= 解压完成,开始安装 ============================="
chmod 755 *.ipk
opkg install *.ipk --force-depends && mv dockerd /etc/config && /etc/init.d/dockerd start 
rm -r *.ipk
TIME g "============================= Docker安装完成 ==============================="
break
;;
2)
echo
TIME g "[2] 安装 青龙面板 主路由模式"
echo
TIME g "跳转到 mnt/mmcblk2p4 目录"
cd /mnt/mmcblk2p4
echo
TIME g "开始下载安装青龙面板..."
echo
docker run -dit \
   -v $PWD/ql/data:/ql/data \
   -p 5700:5700 \
   --name qinglong \
   --hostname qinglong \
   --restart always \
   whyour/qinglong:latest
echo
TIME g "====== 安装完成 浏览器访问 http://N1的IP:5700 进入页面进行后续相关设置 ======"
break
;;
3)
echo
TIME g "[3] 安装 青龙面板 旁路由模式"
echo
TIME g "跳转到 mnt/mmcblk2p4 目录"
cd /mnt/mmcblk2p4
echo
TIME g "开始下载安装青龙面板..."
echo
docker run -dit \
   -v $PWD/ql/data:/ql/data \
   --net host \
   --name qinglong \
   --hostname qinglong \
   --restart always \
   whyour/qinglong:latest
echo
TIME g "====== 安装完成 浏览器访问 http://N1的IP:5700 进入页面进行后续相关设置 ======"
break
;;
4)
echo
TIME g "[4] 安装 elecV2P面板 主路由模式"
echo
TIME g "跳转到 mnt/mmcblk2p4 目录"
cd /mnt/mmcblk2p4
TIME g "开始下载安装 elecV2P 面板..."
echo
docker run --restart=always \
  -d --name elecv2p \
  -e TZ=Asia/Shanghai \
  -p 8100:80 -p 8101:8001 -p 8102:8002 \
  -v elecv2p/JSFile:/usr/local/app/script/JSFile \
  -v elecv2p/Lists:/usr/local/app/script/Lists \
  -v elecv2p/Store:/usr/local/app/script/Store \
  -v elecv2p/Shell:/usr/local/app/script/Shell \
  -v elecv2p/rootCA:/usr/local/app/rootCA \
  -v elecv2p/efss:/usr/local/app/efss \
elecv2/elecv2p
echo
TIME g "====== 安装完成 浏览器访问 http://N1的IP:8100 进入页面进行后续相关设置 ======"
break
;;
5)
echo
TIME g "[5] 安装 elecV2P面板 旁路由模式"
echo
TIME g "跳转到 mnt/mmcblk2p4 目录"
cd /mnt/mmcblk2p4
echo
TIME g "开始下载安装 elecV2P 面板..."
echo
curl -LO https://raw.githubusercontent.com/Wlbak/N1docker-install/main/docker-compose.yaml
docker-compose up -d
echo
TIME g "====== 安装完成 浏览器访问 http://N1的IP:8100 进入页面进行后续相关设置 ======"
break
;;
0)
echo
TIME r "您选择了 [0] 退出 安装菜单"
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
