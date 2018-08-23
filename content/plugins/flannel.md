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

Flannel is CNI Calico is a CNI (Container Network Interface) plugin for Kubernetes. It allows configuring a layer 3 network fabric designed for Kubernetes.


## When to use Flannel
Flannel is used as one of CNI network plugins. It doesn't support Network Policy in Kubernetes. Flannel is responsible for distributing a subnet lease to each host out of a larger, preconfigured address space.
Flannel uses API Kubernetes or directly etcd to store network configuration. Packages are sent using one of several backend mechanisms, including VXLAN.

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

After kubeadm initialisation run:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```

Note that flannel works on amd64, arm, arm64 and ppc64le, but until flannel v0.11.0 is released you need to use the following manifest that supports all the architectures:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/c5d10c8/Documentation/kube-flannel.yml
```

For more information about flannel, see [the CoreOS flannel repository on GitHub](https://github.com/coreos/flannel).
