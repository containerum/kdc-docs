---
title: Bootstrapping Workers
linktitle: Bootstrap Workers
description: Bootstrapping three worker nodes for Kubernetes cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "installation"
    weight: 8

draft: false
---

# Initialize worker nodes

This section covers how to launch three worker nodes and install the following components: [runc](https://github.com/opencontainers/runc), [gVisor](https://github.com/google/gvisor), [container networking plugins](https://github.com/containernetworking/cni), [containerd](https://github.com/containerd/containerd), [kubelet](https://kubernetes.io/docs/admin/kubelet), [kube-proxy](https://kubernetes.io/docs/concepts/cluster-administration/proxies).

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

curl -OL https://storage.googleapis.com/kubernetes-the-hard-way/runsc \
  -OL https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64 \
  -OL https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz \
  -OL https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz
sudo yum install kubernetes-node-meta

{{< / highlight >}}
```

Create installation directories:

```bash
{{< highlight bash >}}

sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes \
  /etc/kubernetes/pki

{{< / highlight >}}
```

Install:

```bash
{{< highlight bash >}}

chmod +x runc.amd64 runsc
sudo mv runc.amd64 runc
sudo mv runc runsc /usr/local/bin/
mkdir cni
sudo tar -xvf cni-plugins-amd64-v0.6.0.tgz -C cni/
sudo mv cni/* /opt/cni/bin/
mkdir containerd/
sudo tar -xvf containerd-1.1.0.linux-amd64.tar.gz -C containerd/
sudo mv containerd/bin/* /bin/

{{< / highlight >}}
```

Add google kubernetes repository:
```bash
{{< highlight bash >}}

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

{{< / highlight >}}
```

Install cri-tools for crictl availabity on the worker node from the google kubernetes repository:
```bash
sudo yum install cri-tools
```

### Configure the CNI network

*NOTE! If you plan to use calico or other network plugin, do not follow this step*

Specify the Pod CIDR IP range for the current node:

<!-- (TODO): How do we specify POD_CIDR -->

```bash
POD_CIDR=10.244.0.0/16
```

Create the `bridge` network:

```bash
{{< highlight bash >}}

cat <<EOF | sudo tee /etc/cni/net.d/10-bridge.conf
{
    "cniVersion": "0.3.1",
    "name": "bridge",
    "type": "bridge",
    "bridge": "cnio0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "${POD_CIDR}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
    }
}
EOF

{{< / highlight >}}
```

Create the `loopback` network:

```bash
{{< highlight bash >}}

cat <<EOF | sudo tee /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "type": "loopback"
}
EOF

{{< / highlight >}}
```

### Configure containerd

Create the `containerd` configuration file:

```bash
{{< highlight bash >}}

sudo mkdir -p /etc/containerd/

{{< / highlight >}}
```

```bash
{{< highlight bash >}}

cat << EOF | sudo tee /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
    [plugins.cri.containerd.untrusted_workload_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runsc"
      runtime_root = "/run/containerd/runsc"
EOF

{{< / highlight >}}
```

Create the `containerd.service` systemd unit file:

```bash
{{< highlight bash >}}

cat <<EOF | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

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
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy

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
worker-0   Ready     <none>    20s       v1.10.2
worker-1   Ready     <none>    20s       v1.10.2
worker-2   Ready     <none>    20s       v1.10.2
```

**Note**: Some nodes may have a status different from `Ready`. It's normal if some nodes are restarting.

Done!

Now you can proceed to [configuring Flannel](/kubernetes/installation/8flannel).
