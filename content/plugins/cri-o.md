---
title: Cri-o
linktitle: Cri-o
description: How to install Cri-o

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 3
    identifier: cri-o

draft: true
---
# How to install Cri-o
Cri-o is one of container runtimes used in Kubernetes. Container runtime is software responsible for launching containers.

CDK версии 1.11.2 рекомендуется использовать с версиями Cri-o 1.11.2.

## Особенности этого runtime

В отличии от Docker, Cri-o более легковесный в качестве runtime для Kubernetes.


## Cri-o install:

Centos:  

Установите зависимости:  
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

Для работы Cri-o необходимо установить runc (The OCI runtime to launch the container).
```bash:
curl -OL https://github.com/opencontainers/runc/releases/download/v1.0.0-rc4/runc.amd64
chmod +x runc.amd64
sudo mv runc.amd64 /usr/bin/runc
```

Посмотрите установленную версию:
```bash
runc -version
```
```bash
runc version 1.0.0-rc4
spec: 1.0.0
```

Установите crictl:
```bash
VERSION="v1.11.1"
wget https://github.com/kubernetes-incubator/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
```

Склонируйте репозиторий cri-o и переключитесь на тег вашей версии. Для Kubernetes v1.11.* мы используем v1.11.2:
```bash
git clone https://github.com/kubernetes-incubator/cri-o
cd cri-o
git checkout v1.11.2
```

Сборка и установка:  
```bash
make install.tools
```

```bash
make
```

```bash
sudo make install
```

Если cri-o устанавливается впервый раз, то необходимо сгенерировать файлы конфигурации:
```bash
sudo make install.config
```

Запустите system daemon для crio:
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

Проверьте работу cri-o:
```bash
sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock version
```

```bash
Version:  0.1.0
RuntimeName:  cri-o
RuntimeVersion:  1.11.2
RuntimeApiVersion:  v1alpha1
```

Инициализируйте кластер kubernetes:

```
modprobe br_netfilter

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
sudo sysctl -p

kubeadm init --cri-socket="/var/run/crio/crio.sock"
```