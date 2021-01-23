# openwrt_update
openwrt固件编译脚本！

【比较完美了·暂处于稳定期】【欢迎使用！】

【相比之前的脚本，全新编写，更加精准和科学！】

1.平台是基于win10 wsl2环境的linux 当然也可以运行到其他地方Linux上，只要注意目录逻辑问题（参考第3项说明）

2.前提是自己配置好了lean大佬lede源码，以及配置好openclash、passwall并成功编译过（路径、源码配置等参考第3项说明）

3.关于脚本路径以及配置lede大雕们源码路径问题【务必认真阅读，非常重要！】：
    
    a.登录win10的wls2后，首先运行 cd 命令回到自己用户主页后：git clone https://github.com/coolsnowwolf/lede拉去
    lede固件；passwall是在lede源码的feeds.conf.default文件里添加src-git passwall https://github.com/xiaorouji/openwrt-passwall即可；
    b.关于OpenClash项目则是根据https://github.com/vernesong/OpenClash/tree/master 里面的 “# Clone 项目”配置即可；
    c.这样子配置好就和脚本形成了相对对应的路径关系了，从而可以顺利运行脚本了；
    d.由于重命名脚本写死缘故，同时也是为了解压固件体积，建议选择压缩（运行make menuconfig命令，在Target Images下勾选[*] GZip images）
    e.之所以只写步骤而不是把源码配置加入脚本，就是为了防止友友们太无脑操作，稍微动动手。
4.一键脚本运行：

    cd && bash -c "$(wget -O- https://git.io/Jt3f6)"

5.若有问题讨论群：https://t.me/openwrt_lede_v2ray_plugin
