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

draft: false
---
# How to install containerd
Containerd is one of container runtimes used in Kubernetes. Container runtime is software responsible for launching containers.

It is recommended to use KDC with containerd v1.1.3, but versions 1.0.\*, 1.1.\* are also supported.

## Description
Containerd is used in the same way as Docker. Containerd as a container runtime in Kubernetes allows for the highest performance when launching containers due to the lack of excessive interfaces between Kubelet and the system.


## Containerd installation:
For Centos:

Download, extract and start containerd:
```bash
curl -OL https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.3.linux-amd64.tar.gz
tar --no-overwrite-dir -C / -xzf cri-containerd-1.1.3.linux-amd64.tar.gz
systemctl daemon-reload
systemctl enable containerd
systemctl start containerd
```

Configure network and initialize Kubernetes:

```bash
modprobe br_netfilter

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
sudo sysctl -p

kubeadm init --cri-socket="/var/run/containerd/containerd.sock"
```

Done!

For more information refer to [containerd documentation](https://github.com/containerd/containerd/blob/master/docs/getting-started.md).
