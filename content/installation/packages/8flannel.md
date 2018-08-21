---
title: Flannel Installation
linktitle: Flannel
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

Flannel is an etcd backed overlay network for containers. Download the Flannel networking manifest:

```bash
curl -OL https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

If you do not want to use pod-cird=10.244.0.0/16 then change it in kube-flannel.  
Apply the manifest with:

```
kubectl apply -f kube-flannel.yml
```

Done!

Now you can proceed to [configuring DNS](/installation/packages/9dns).
