---
title: Bootstrapping Workers
linktitle: Bootstrap Workers
description: Bootstrapping three worker nodes for Kubernetes cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 8

draft: false
---

# Initialize worker nodes

This section covers how to launch three worker nodes and install the following components: [runc](https://github.com/opencontainers/runc), [container networking plugins](https://github.com/containernetworking/cni), [containerd](https://github.com/containerd/containerd), [kubelet](https://kubernetes.io/docs/admin/kubelet), [kube-proxy](https://kubernetes.io/docs/concepts/cluster-administration/proxies).

> **Don't forget to run these commands on all worker nodes.**

## Provision a worker node

Install the OS dependencies:

```bash
{{< highlight bash >}}

sudo yum update
sudo yum -y install socat conntrack ipset

swapoff -a

{{< / highlight >}}
```
> **Don't forget to turn off swap completely in /etc/fstab.**
> `socat` enables support for `kubectl port-forward` command.

### Download and install the components binaries

```bash
{{< highlight bash >}}

sudo yum install kubernetes-node-meta

{{< / highlight >}}
```

### Install CRI-O

Kubernetes supports various container runtimes. By default this installation uses CRI-O. To install and configure alternative runtimes consult the [plugins](/plugins) section.

```bash
{{< highlight bash >}}

yum install cri-o cri-tools -y
systemctl enable cri-o && systemctl start cri-o

{{< / highlight >}}
```

To use CRI-O as kubernetes runtime chane kubelet parameters in ```/etc/sysconfig/kubelet```:

```bash
{{< highlight bash >}}

cat /etc/sysconfig/kubelet
# Container runtime to use. Possible values: docker, remote.
KUBELET_RUNTIME=remote
# The endpoint of remote runtime service.
KUBELET_RUNTIME_ENDPOINT=unix:///var/run/crio/crio.sock


{{< / highlight >}}
```

### Configure Kubelet

```bash
{{< highlight bash >}}

sudo cp ca.crt /etc/kubernetes/pki/
sudo cp $HOSTNAME.crt /etc/kubernetes/pki/node.crt
sudo cp $HOSTNAME.key /etc/kubernetes/pki/node.key
sudo cp $HOSTNAME.kubeconfig /etc/kubernetes/kubelet.kubeconfig

{{< / highlight >}}
```

### Configure Kubernetes Proxy

```bash
{{< highlight bash >}}

sudo cp kube-proxy.kubeconfig /etc/kubernetes

{{< / highlight >}}
```

### Start services on the worker nodes

```bash
{{< highlight bash >}}

sudo systemctl daemon-reload
sudo systemctl enable kubernetes.target kubelet kube-proxy
sudo systemctl start kubernetes.target kubelet kube-proxy

{{< / highlight >}}
```

## Verification
Print the list of nodes:

```bash
kubectl get nodes
```

> Output

```
NAME       STATUS    ROLES     AGE       VERSION
node-01   Ready     <none>    20s       v1.10.2
node-02   Ready     <none>    20s       v1.10.2
node-03   Ready     <none>    20s       v1.10.2
```

**Note**: Some nodes may have a status different from `Ready`. It's normal if some nodes are restarting.

Done!

Now you can proceed to [Calico set up](/installation/packages/8calico).
