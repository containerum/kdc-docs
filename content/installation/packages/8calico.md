---
title: Calico Installation
linktitle: Install Calico
description: Installing Calico - an overlay network for the cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 9

draft: false
---

# Install Calico

Calico is an overlay network for containers. Download the Calico networking manifest:

```bash
curl -O https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/calico.yaml
```

Now time to configure calico!
For run Calico it needs to be connected to etcd database. We will use same database as kubernetes. First you need to set etcd address in calico.yaml:
```
etcd_endpoints: "https://192.168.0.1:2379,https://192.168.0.1:2379,https://192.168.0.1:2379"
```
Then uncomment certificates paths in calico-config ConfigMap:
```
etcd_ca: "/calico-secrets/etcd-ca"
etcd_cert: "/calico-secrets/etcd-cert"
etcd_key: "/calico-secrets/etcd-key"
```
To allow Calico connect to etcd you need ~~~
```
```
If you do not want to use pod-cird=10.244.0.0/16 then change it in kube-flannel.  

Done!

Now you can proceed to [configuring DNS](/installation/packages/9dns).
