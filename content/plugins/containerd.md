---
title: Containerd
linktitle: Containerd
description: How to install Containerd

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 4
    identifier: containerd

draft: true
---
# How to install containerd
Containerd это TVOY TEKST TUT. Он нужен для того, чтобы TVOY TEKST TUT.

CDK рекомендуется использовать с версиями containerd такими-то, такими-то. Проблемы могут быть с такими.

## Особенности этого runtime
Чем отличается от docker и cri-o - в каких случаях лучше containerd


## Containerd install:
Centos:

Скачайте и распакуйте containerd:
```bash
curl -OL https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.3.linux-amd64.tar.gz
tar --no-overwrite-dir -C / -xzf cri-containerd-1.1.3.linux-amd64.tar.gz
systemctl daemon-reload
systemctl enable containerd
systemctl start containerd
```


```bash
modprobe br_netfilter

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
sudo sysctl -p

kubeadm init --cri-socket="/var/run/containerd/containerd.sock"
```