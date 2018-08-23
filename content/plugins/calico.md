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

After kubeadm has been initialized, run:

```bash
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```
Read more in [the official documentation](https://docs.projectcalico.org/v3.1/getting-started/kubernetes/).
