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
Docker это один из “Container Runtime” используемых в Kubernetes. "Container runtime" это программное обеспечение, которое отвечает за запуск контейнеров.

CDK рекомендуется использовать с Docker v1.13.1, v17.03.2. Может работать с версиями выше, но тестирование не произвонидилось и могут возникнуть проблемы.

## Особенности этого runtime
Docker - классический container runtime для Kubernetes. В сравнении с CRI-O более тяжеловесен. Устанавливается из коробки
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
```bash
$ curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
$ sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
$ sudo apt-get update
$ sudo apt-get -y install docker-engine
$ sudo sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
$ sudo systemctl daemon-reload
$ sudo systemctl start docker && sudo systemctl enable docker
```