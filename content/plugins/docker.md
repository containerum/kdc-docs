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
Docker is one of container runtimes used in Kubernetes. Container runtime is software responsible for launching containers.

It is recommended to use CDK with Docker v1.13.1, v17.03.2. CDK also supports higher Docker versions, but compatibility is not guaranteed.

## Description
Docker is a classic container runtime for Kubernetes. Runs out-of-the-box.


## Docker 1.13.1 installation:

**CentOS:**
```
$ sudo yum install docker
$ sudo sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
$ sudo systemctl daemon-reload
$ sudo systemctl start docker && sudo systemctl enable docker
```

**Ubuntu:**  
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
