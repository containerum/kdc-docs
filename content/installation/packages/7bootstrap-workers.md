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

> **Don't forget to run all commands on all worker nodes.**

## Provision a worker node

Install the OS dependencies:

```bash
{{< highlight bash >}}

sudo yum update
sudo yum -y install socat conntrack ipset

{{< / highlight >}}
```

> `socat` enables support for `kubectl port-forward` command.

### Download and install the components binaries

```bash
{{< highlight bash >}}

sudo yum install kubernetes-node-meta

{{< / highlight >}}
```

Create installation directories:

```bash
{{< highlight bash >}}

sudo mkdir -p \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes \
  /etc/kubernetes/pki

{{< / highlight >}}
```

### Install docker

Kubernetes suports many different runtimes. By default use docker. Alternative rintimes installation and configuration describes in [plugins](/plugins) section.

```bash
{{< highlight bash >}}

yum install docker
sed -i 's/native.cgroupdriver=systemd/native.cgroupdriver=cgroupfs/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload
systemctl enable docker && systemctl start docker

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

sudo mv kube-proxy.kubeconfig /etc/kubernetes

{{< / highlight >}}
```

### Start services on the worker nodes

```bash
{{< highlight bash >}}

sudo systemctl daemon-reload
sudo systemctl enable kubernetes.target
sudo systemctl start kubernetes.target

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

Now you can proceed to [configuring Flannel](/installation/packages/8flannel).
