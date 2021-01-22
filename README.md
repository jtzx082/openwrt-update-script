# openwrt_update
openwrt固件编译脚本！

相比之前的脚本，全新编写，更加精准和科学！

1.平台是基于win10 wsl2环境 当然自己改改就可以Linux上

2.前提是自己配置好了lean大佬lede源码，以及配置好openclash、passwall并成功编译过（路径问题参考第3项说明）

3.关于脚本路径以及配置lede大雕们源码路径问题：
    
    a.登录win10的wls2后，首先运行 cd 命令回到自己用户主页后：git clone https://github.com/coolsnowwolf/lede 拉去lede固件；passwall是在lede源码
    的feeds.conf.default文件里添加src-git passwall https://github.com/xiaorouji/openwrt-passwall即可；
    b.关于OpenClash项目则是根据https://github.com/vernesong/OpenClash/tree/master 里面的 “# Clone 项目”配置即可；
    c.这样子配置好就和脚本形成了相对对应的路径关系了，从而可以顺利运行脚本了。
4.一键脚本运行：

    cd && bash -c "$(wget -O- https://git.io/Jt3f6)"

5.若有问题讨论群：https://t.me/openwrt_lede_v2ray_plugin
