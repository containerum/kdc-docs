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

Now it's time to configure calico!
To run Calico it needs to be connected to etcd database. We will use same database as Kubernetes do.

At first you need to set up etcd address in `calico.yaml`:

Sure, you can use only one etcd server in this config.
```
etcd_endpoints: "https://${ETCD_NODE_1_IP}:2379,https://${ETCD_NODE_2_IP}:2379,https://${ETCD_NODE_3_IP}:2379"
```
Next uncomment certificate paths in `calico.yaml` ConfigMap:
```
etcd_ca: "/calico-secrets/etcd-ca"
etcd_cert: "/calico-secrets/etcd-cert"
etcd_key: "/calico-secrets/etcd-key"
```
To allow Calico connect to Kubernetes etcd you need add certificates to yaml Secrets section:

You have to encode certificates in base64 removing newlines, you can use this command for ca, key and cert:
```bash
cat ca.crt | base64 -w0
```
Paste output into fields:
```
etcd-key: "<output>"
etcd-cert: "<output>"
etcd-ca: "<output>"
```
If you do not want to use pod-cidr=192.168.0.0/16 then update "CALICO_IPV4POOL_CIDR" value in yaml. Use same CIDR as in other config files.

> **It's also recommended to define default interface for Calico traffic, just add IP_AUTODETECTION_METHOD to env variables in `calico.yaml`.**

# Enable BGP in Calico

If we have everything done right, we need to proceed with BGP configuration in Calico.

First of all, we need to get calicoctl utility, to do this you can add pod for calicoctl:

```
kubectl apply -f https://docs.projectcalico.org/v2.3/getting-started/kubernetes/installation/hosted/calicoctl.yaml
```

> Run commands with this syntax:
```bash
kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide
```

```bash
cat << EOF | kubectl exec -ti -n kube-system calicoctl -- /calicoctl create -f -
apiVersion: projectcalico.org/v3
kind: BGPConfiguration
metadata:
  name: default
spec:
  logSeverityScreen: Info
  nodeToNodeMeshEnabled: true
  asNumber: 63400
EOF;
```

Done!

Now you can proceed to [configuring DNS](/installation/packages/9dns).
