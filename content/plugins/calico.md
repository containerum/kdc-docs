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

Calico  - CNI плагин, используемый в Kubernetes. 

Рекомендуемая версия для Kubernetes v1.11.2: v3.1  


## When to use Calico
Calico поддерживает NetworkPolicy. Calico была выбрана в качестве эталонной реализации сетевой политики для Kubernetes. Calico network policy can also be specified using the Calico command line tools and APIs, either in place of or augmenting the policy concepts provided by the orchestration system.

## Installation
In order for Network Policy to work correctly, you need to pass `--pod-network-cidr=192.168.0.0/16` to `kubeadm init`. Note that Calico works on amd64 only.

```bash
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
```