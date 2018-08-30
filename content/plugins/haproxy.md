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

draft: false
---

# How to install HAProxy for Kubernetes

Ingress Controller is required to access applications running in Kubernetes by an External IP.  

## Description
HAProxy can be used as an alternative to Nginx.

## Installation

Run:
```bash
kubectl create -f https://raw.githubusercontent.com/jcmoraisjr/haproxy-ingress/master/docs/haproxy-ingress.yaml
```

HAProxy is installed as a DaemonSet on the nodes labelled as `role=ingress-controller`. We recommend provisioning separate nodes that will be responsible for traffic balancing through HAProxy. To label a node as `ingress-controller` run:
```bash
kubectl label node <node-name> role=ingress-controller
```
Don't forget to replace ``<node-name>`` with the node name.

Done!

For more information about HAProxy see [the docs on GitHub](https://github.com/jcmoraisjr/haproxy-ingress).
