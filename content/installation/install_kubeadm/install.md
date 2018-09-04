---
title: Installing CDK with kubeadm
linktitle: Install
description: How to install Containerum Distribution of Kubernetes with kubeadm

categories: []
keywords: []

menu:
  docs:
    parent: "installation_kubeadm"
    weight: 2
    identifier: cdk_kubeadm

draft: false
---

# Preparation
You can install a single-master Kubernetes cluster or a high-availability cluster. Read more about cluster requirements [here](/installation/prerequirements).

Currently installation with kubeadm is availble only for machines with CentOS 7.

## Install Docker
To install Docker run:

```
yum install -y docker
systemctl enable docker && systemctl start docker
```

Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed. You should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
```
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf
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

## Set Containerum repository
Create a /etc/yum.repos.d/kubeadm_1_10.repo file as follows:

```
[exonlab-kubernetes1_10]
baseurl = http://repo.containerum.io/centos/7/kubernetes-1_10-classic/x86_64/
gpgcheck = 1
gpgkey = https://repo.containerum.io/RPM-GPG-KEY-ExonLab
name = Exon lab kubernetes repo for CentOS
repo_gpgcheck = 1
```

Then run:
```
yum update
```

## Install kubeadm, kubectl, and kubelet

Kubeadm is a tool for bootstraping a Kubernetes cluster, kubectl is a command line tool for Kubernetes, and kubelet is a client for managing worker nodes in Kubernetes. Run:

```
yum install kubeadm kubelet kubectl
systemctl enable kubelet && systemctl start kubelet
```

## Initialize kubeadm
After the components have been installed, run `kubeadm init <args>`.
Choose the CNI plugin you are going to use ([Calico](/plugins/calico) or [Flannel](/plugins/flannel) are recommended) and pass args to kubeadm init.

**For Flannel run:**
```
kubeadm init --pod-network-cidr=10.244.0.0/16
```

**For Calico run:**
```
kubeadm init --pod-network-cidr=192.168.0.0/16
```
## Master isolation
If you are building a single-node cluster, you have to allows scheduling pods on the master:

```
kubectl taint nodes --all node-role.kubernetes.io/master-
```
