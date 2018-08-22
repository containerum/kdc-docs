---
title: Docker
linktitle: Docker
description: How to install Docker

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 2
    identifier: docker

draft: false
---
# How to install Docker
Docker это TVOY TEKST TUT. Он нужен для того, чтобы TVOY TEKST TUT.

CDK рекомендуется использовать с версиями Docker такими-то, такими-то. Проблемы могут быть с такими.

## Особенности этого runtime
Чем отличается от cri-o и containerd - в каких случаях лучше Docker


## Docker 1.13.1 install:
На CentOS:
```
$ sudo yum install docker
$ sudo sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
$ sudo systemctl daemon-reload
$ sudo systemctl start docker && sudo systemctl enable docker
```
На Ubuntu:
MEGATEKST HERE
