---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Ubuntu关闭笔记本休眠"
subtitle: ""
summary: ""
authors: []
tags: ['ubuntu', 'hibernate']
categories: []
date: 2019-11-15T20:59:24+08:00
lastmod: 2019-11-15T20:59:24+08:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---
# Ubuntu关闭笔记本盖休眠

## 背景

不知道从什么时候开始, 就逐渐喜欢上了电脑不关机, 打开盖子一切都是上次关闭的样子, 马上就可以开始继续干活. Windows, Mac和Linux我都用过, Mac合盖并不会关机, 但是由于其较为卓越的电源管理和电池, 所以基本可以做到用完就合盖, 打开接着干, 确实非常方便, Windows的话, 在Win10+SSD的加持下, 打开休眠选项并设置合盖即休眠可以非常简单就达到效果, 所以win10下除了不时的更新强制重启外我也很少关机, 都是用完一合盖子拉倒

就Linux下, 或者Ubuntu来说, 这个功能是没有的, 有的是一个`suspend`的功能, 但是在我看来这个更像是深一点的睡眠功能, 类似Mac? 总之不时很满意, 因为我的笔记本是一个老式的二手ThinkPad, 电池并不好, 所以经常会在`suspend`一段时间后关机, 所有的工作场景都没了, 开机还得从头来过, 非常不爽, 之前一直想找时间给ubuntu加上这块, 最近因为又开始给老婆写一个PDF转换工具, 突突突搞了几天, 趁着休息的空挡搞了一下, 然后记录一下过程和坑

## 正片

首先声明, 本文是在Ubuntu 19.10环境下写的, 在我的机子上测试通过

### 测试

首先测试是否支持休眠, 注意以下命令会导致休眠, 如果功能不完整(比如我), 会导致无法正确保存当前任务, 请先处理好后再测试

    sudo systemctl hibernate

如果没有成功, 那估计是没有设置`swap`分区导致的, 这块我也不是特别清除, 因为这块我是没有问题的

另外注意是的, swap的大小最好略大于内存, 否则无法报错内存数据, 可能会在某些场景下休眠失败

如果有这个命令, 但是开机后还是和重启了一样, 那么恭喜, 我们可以进入下一个环节了

### 设置swap保存内存数据

首先找到swap的文件路径

    grep swap /etc/fstab

找到类似如下内容

    /dev/mapper/ubuntu--vg-swap   none            swap    sw

`/dev/mapper/ubuntu--vg-swap`即为swap分区路径(我用的lvm, 此处格式可能会有差异)

添加启动参数

    sudo vim /etc/default/grub

在`GRUB_CMDLINE_LINUX_DEFAULT`字段中增加如下内容, 注意替换路径为你的swap路径, 这个字段我之前修改过, 如果你没有修改, 此处应该还有`quiet splash`的字样, 删掉这两个字段可以让开机时显示详细开机信息, 我比较喜欢看开机的信息, 比只盯着Ubuntu的那个LOGO看感觉上要好点, 如果你有, 那么就加在末尾就好了, 空格分割

这里有个坑就是, 我开始在网上找的都是使用的swap的UUID, 然而我自己的测试是不能成功, 使用文件路径可以, 不知道是不是我哪里弄错了, 如果你用路径不成功, 可以换UUID试一下

    GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/mapper/ubuntu--vg-swap"

OK, 接下来就是执行`sudo update-grub`让启动项的设置生效, 这个很重要, 我自己设置的时候就是这个地方开始没有注意到, 导致失败, 然后重启, 进入系统后, 可以继续执行我们最开始的命令测试了

    sudo systemctl hibernate

等电源灯熄灭后开机, 如果一切正常, 此时开机后就会恢复上次休眠时的内容了, 搞定

## 合盖休眠

到这步为止, 系统已经可以正常休眠了, 但是每次敲命令肯定是有点不方便的, 那么我们接下来就是设置笔记本的合盖休眠了

这里有两个途径, 一个是使用`dconf`设置, 我测试没有成功, 此处介绍另一种, 直接修改文件

### 设置dconf

首先是设置dconf, 如果你没有设置过, 先安装设置工具

    sudo apt install dconf-editor

打开如下路径`/org/gnome/settings-daemon/plugins/power/`

- 设置`lid-close-ac-action` -> `nothing`
- 设置`lid-close-battery-action` -> `nothing`

此处还可以设置为挂起(suspend)或者睡眠, 但是设置为休眠时无效, 所以为了使用文件方式, 此处设置为`nothing`

接下来修改文件

    sudo vim /etc/systemd/logind.conf

取消注释如下两行, 并修改值为`hibernate`

    HandleLidSwitch=hibernate
    HandleLidSwitchDocked=hibernate     # 此处为外接显示器时合盖操作, 但我测试没有生效, 如果没有外接显示器, 可不设置

重启服务

    sudo systemctl restart systemd-logind.service

### 添加顶部菜单休眠键

创建设置文件

    sudo vim /etc/polkit-1/localauthority/50-local.d/enable-hibernate.pkla

添加如下内容

``` conf
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
```

如果是较新的使用gnome的Ubuntu版本, 添加[扩展][1], 然后就顶部菜单栏就会出现休眠按钮, 大功告成

## TODO

- 外接显示器的合盖操作一直没有成功
- 合盖休眠再打开会直接开机, 目前我没有设置关闭此功能, 后续看需求测试一下, 也给出[参考地址][2]

## 参考

> - <https://askubuntu.com/a/821122/537695>
> - <https://askubuntu.com/a/94963/537695>
> - <http://tipsonubuntu.com/2016/10/24/ubuntu-16-10-auto-shutdown-hibernate-lid-closed/>

[1]: <https://extensions.gnome.org/extension/755/hibernate-status-button/>
[2]: <https://superuser.com/a/68079/603441>
