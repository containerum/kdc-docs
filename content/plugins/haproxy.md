---
title: HAProxy
linktitle: HAProxy
description: Installing HAProxy to access applications in Kubernetes by an External IP.

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 6
    identifier: haproxy

draft: true
---

# How to install HAProxy for Kubernetes

Ingress Controller is required to access applications running in Kubernetes by an External IP. Рекомендуемая версия: без разницы

[https://github.com/jcmoraisjr/haproxy-ingress](https://github.com/jcmoraisjr/haproxy-ingress)

## When to use HAProxy
Используйте HAProxy в качестве альтернативы Nginx.

## Installation

Запустить через kubectl.:
```bash
kubectl create -f https://raw.githubusercontent.com/jcmoraisjr/haproxy-ingress/master/docs/haproxy-ingress.yaml
```

HAProxy устанавливается как DaemonSet на nodes имеющих label role=ingress-controller. Мы рекомендуем выделить отдельные nodes, которые будут заниматься балансировкой трафика через HAProxy. Вместо <node-name> укажите имена nodes. 
```bash
kubectl label node <node-name> role=ingress-controller
```