---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "CAP定理"
subtitle: ""
summary: ""
authors: []
tags: ['concept', 'CAP']
categories: []
date: 2019-09-29T00:40:08+08:00
lastmod: 2019-09-30T00:40:08+08:00
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

## 概念

- 分布式系统：在互相隔离的空间中，提供数据服务的系统。
- CAP抽象：不同空间的数据，在同一时间，状态一致。

## 解释

    C：代表状态一致
    A：代表同一时间
    P：代表不同空间
    CP:不同空间中的数据，如果要求他们所有状态一致，则必然不在同一时间。
    AP:不同空间中，如果要求同一时间都可以从任意的空间拿到数据，则必然数据的状态不一致。
    CA:不同空间的数据，如果要求任意时间都可以从任意空间拿到状态一致的数据，则空间数必然为1.
