---
title: Cri-o
linktitle: Cri-o
description: How to install cri-o

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 3
    identifier: cri-o

draft: false
---
# How to install cri-o
Cri-o is one of container runtimes used in Kubernetes. Container runtime is software responsible for launching containers.

It is recommended to use KDC 1.11.2 with cri-o 1.11.2.

## Description

Compared to Docker, cri-o is a more lightweight runtime for Kubernetes.


## сri-o installation:

For CentOS:  

Install the dependencies:  
```bash
yum install -y \
  btrfs-progs-devel \
  device-mapper-devel \
  git \
  glib2-devel \
  glibc-devel \
  glibc-static \
  go \
  golang-github-cpuguy83-go-md2man \
  gpgme-devel \
  libassuan-devel \
  libgpg-error-devel \
  libseccomp-devel \
  libselinux-devel \
  ostree-devel \
  pkgconfig \
  runc \
  skopeo-containers
```

First install runc (The OCI runtime to launch the container):
```bash:
curl -OL https://github.com/opencontainers/runc/releases/download/v1.0.0-rc4/runc.amd64
chmod +x runc.amd64
sudo mv runc.amd64 /usr/bin/runc
```

Check the version:
```bash
runc -version
```
Output:  
```bash
runc version 1.0.0-rc4
spec: 1.0.0
```

Install crictl:
```bash
VERSION="v1.11.1"
wget https://github.com/kubernetes-incubator/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
```

Clone the cri-o repo and switch to the required version. We recommend using v1.11.2 for Kubernetes v1.11.* :
```bash
git clone https://github.com/kubernetes-incubator/cri-o
cd cri-o
git checkout v1.11.2
```

Build and install cri-o:  
```bash
make install.tools
```

```bash
make
```

```bash
sudo make install
```

If you install cri-o for the first time, it is necessary to generate configuration files:
```bash
sudo make install.config
```

Launch system daemon for cri-o:
```bash
sudo sh -c 'echo "[Unit]
Description=OCI-based implementation of Kubernetes Container Runtime Interface
Documentation=https://github.com/kubernetes-incubator/cri-o

[Service]
ExecStart=/usr/local/bin/crio
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/crio.service'
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio
```

Check if cri-o is running:
```bash
sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version
```

```bash
Version:  0.1.0
RuntimeName:  cri-o
RuntimeVersion:  1.11.2
RuntimeApiVersion:  v1alpha1
```

Apply kernel parameters:
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

Initialize the Kubernetes cluster:

```
kubeadm init --cri-socket="/var/run/crio/crio.sock"
```

Done!

For more information refer to [cri-o documentation](https://github.com/kubernetes-incubator/cri-o).
