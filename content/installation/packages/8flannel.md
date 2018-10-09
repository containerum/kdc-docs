---
title: Flannel Installation
linktitle: Install Flannel
description: Installing Flannel - an overlay network for the cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 9

draft: false
---

# Install Flannel

Flannel is an etcd-backed overlay network for containers. Download the Flannel networking manifest:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml
```

Note that flannel works on amd64, arm, arm64 and ppc64le, but until flannel v0.11.0 is released you need to use the following manifest that supports all the architectures:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/c5d10c8/Documentation/kube-flannel.yml
```

If you do not want to use pod-cird=10.244.0.0/16 then change it in kube-flannel.  

Done!

Now you can proceed to [configuring DNS](/installation/packages/9dns).
