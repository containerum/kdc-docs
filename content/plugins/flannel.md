---
title: Flannel
linktitle: Flannel
description: Installing Flannel for networking in Kubernetes.

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 8
    identifier: flannel

draft: false
---

# How to install Flannel for Kubernetes

Flannel is a simple and easy way to configure a layer 3 network fabric designed for Kubernetes.


## When to use Flannel
Flannel используется как один из плагинов cni в Kubernetes для реализации сети. Не поддерживает Network Policy в Kubernetes. Отвечает за распределение аренды подсетей каждому хосту из большего, предварительно сконфигурированного адресного пространства. Flannel использует API Kubernetes или etcd напрямую для хранения сетевой конфигурации. Пакеты пересылаются с использованием одного из нескольких бэкэнд-механизмов, включая VXLAN.

## Installation
For flannel to work correctly, you must pass --pod-network-cidr=10.244.0.0/16 to kubeadm init

Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed. You should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
```
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```


```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```

Note that flannel works on amd64, arm, arm64 and ppc64le, but until flannel v0.11.0 is released you need to use the following manifest that supports all the architectures:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/c5d10c8/Documentation/kube-flannel.yml
```

For more information about flannel, see [the CoreOS flannel repository on GitHub](https://github.com/coreos/flannel).