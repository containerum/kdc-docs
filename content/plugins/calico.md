---
title: Calico
linktitle: Calico
description: Installing Calico for networking in Kubernetes.

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 9
    identifier: calico

draft: false
---

# How to install Calico for Kubernetes

Calico is a CNI (Container Network Interface) plugin for Kubernetes.

Recommended version for Kubernetes v1.11.2: Calico v3.1.


## When to use Calico
Calico supports NetworkPolicy. Calico has been chosen as a benchmark implementation of network policy for Kubernetes. Calico network policy can also be specified using the Calico command line tools and APIs, either in place of or augmenting the policy concepts provided by the orchestration system.

## Installation
In order for Network Policy to work correctly, you need to pass `--pod-network-cidr=192.168.0.0/16` to `kubeadm init`. Note that Calico works on amd64 only.

Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed. You should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
```
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

If you get error message like this:
```
sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-ip6tables: No such file or directory
sysctl: cannot stat /proc/sys/net/bridge/bridge-nf-call-iptables: No such file or directory
```
You need to load kernel module br_netfilter:
```
modprobe br_netfilter
cat <<EOF >  /etc/modules-load.d/br_netfilter.conf
br_netfilter
EOF
```

After kubeadm has been initialized, run:

```bash
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```
Read more in [the official documentation](https://docs.projectcalico.org/v3.1/getting-started/kubernetes/).
