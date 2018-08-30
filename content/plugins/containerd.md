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
Containerd is one of container runtimes used in Kubernetes. Container runtime is software responsible for launching containers.

CDK рекомендуется использовать с версиями containerd v1.1.3, но также будут поддерживаться версии 1.0.\*, 1.1.\*

## Особенности этого runtime
Containerd используется тем же Docker. Используя Containerd в качестве container runtime в Kubernetes можно добиться максимальной производительности при запуске контейнеров за счет отсутствия лишних интерфейсов между Kubelet и системой.


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