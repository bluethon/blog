---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Windows开机启动"
subtitle: ""
summary: ""
authors: []
tags: ['win', 'startup']
categories: []
date: 2019-11-11T13:44:15+08:00
lastmod: 2019-11-11T13:44:15+08:00
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

# Windows开机启动设置

## 缘由

今天准备把自己的ahk开机脚本停掉, 就需要打开Windows的开机启动文件夹, 如果自己手动开的话要很长, 然后就搜索能不能从启动直接打开, 最后顺带整理一下, 以便以后查询

## 启动文件夹

这个就是以前常见的开始菜单的开始文件夹, 把快捷方式拖进去就可以达到开机启动的目的, 使用`win+R`打开运行窗口

以下是当前用户的命令

    shell:startup

以下是所有用户的命令

    shell:common startup

## 任务管理器里的启动位置

这个位置就是我们打开任务管理器, 切换到启动标签看到的内容, 这部分需要修改注册表, 还是老样子, 打开运行, 输入`regedit`打开注册表

在以下俩个路径下就是在任务管理器内看到的内容, 是不是有些想清除的其他软件~

    # 本机(所有用户)
    HKLM\Software\Microsoft\Windows\CurrentVersion\Run
    # 当前用户
    HKCU\Software\Microsoft\Windows\CurrentVersion\Run

## 参考

> [文章及评论区](https://www.techjunkie.com/windows-10-startup-folder/)
