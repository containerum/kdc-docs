---
title: Kubeconfig files
linktitle: Create Kubeconfigs
description: Creating Kubernetes authentication configuration files.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 4

draft: false
---

# Create authentication kubeconfig files

## Install kubectl

Kubectl is used to communicate with the Kubernetes API server. Install kubectl:

```
{{< highlight bash >}}
sudo yum install kubernetes-kubectl
{{< / highlight >}}
```

Make sure that kubectl version is 1.10.5 or higher:

```
{{< highlight bash >}}
kubectl version --client

Client Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.5", GitCommit:"32ac1c9073b132b8ba18aa830f46b77dcceb0723", GitTreeState:"archive", BuildDate:"2018-07-06T13:45:52Z", GoVersion:"go1.9.3", Compiler:"gc", Platform:"linux/amd64"}
{{< / highlight >}}
```

## Client authentication configuration file
Create the kubeconfig files for `controller manager`, `kubelet`, `kube-proxy`, `scheduler` and `admin` user as described below.

### Public Kubernetes IP-address

Each kubeconfig file requires Kubernetes API Server for connection. To ensure high availability, the IP-address of your load balancer will determine which Kubernetes API Server will be used.

Specify the `Kubernetes api-server` static IP address:

```bash
KUBERNETES_PUBLIC_IP=${PUBLIC_IP}
```

### Create a kubelet configuration file

When generating kubeconfig for Kubelets, a client certificate matching the Kubelet's node hostname must be used (`node-01 node-02 node-03` in the example below). This will ensure Kubelets are properly authorized by the Kubernetes Node Authorizer.

Create a kubeconfig file for each worker:

```bash
{{< highlight bash >}}

for instance in node-01 node-02 node-03; do
  kubectl config set-cluster containerum \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_IP}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.crt \
    --client-key=${instance}.key \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=containerum \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done

{{< / highlight >}}
```

### Create a kube-proxy configuraton file

Create a kubeconfig file for `kube-proxy`:

```bash
{{< highlight bash >}}

kubectl config set-cluster containerum \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_IP}:6443 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=kube-proxy.crt \
  --client-key=kube-proxy.key \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=containerum \
  --user=system:kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

{{< / highlight >}}
```

### Create a kube-controller-manager configuration file  
Create a kubeconfig file for `kube-controller-manager`:

```bash
{{< highlight bash >}}

kubectl config set-cluster containerum \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_IP}:6443 \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=kube-controller-manager.crt \
  --client-key=kube-controller-manager.key \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=containerum \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

{{< / highlight >}}
```

### Create a kube-scheduler configuration file
Create a kubeconfig file for `kube-scheduler`:

```bash
{{< highlight bash >}}

kubectl config set-cluster containerum \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_IP}:6443 \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=kube-scheduler.crt \
  --client-key=kube-scheduler.key \
  --embed-certs=true \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=containerum \
  --user=system:kube-scheduler \
  --kubeconfig=kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

{{< / highlight >}}
```

###  Create admin user configuration file  
Create a kubeconfig file for `admin` user:

```bash
{{< highlight bash >}}

kubectl config set-cluster containerum \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_IP}:6443 \
  --kubeconfig=admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=admin.crt \
  --client-key=admin.key \
  --embed-certs=true \
  --kubeconfig=admin.kubeconfig

kubectl config set-context default \
  --cluster=containerum \
  --user=admin \
  --kubeconfig=admin.kubeconfig

kubectl config use-context default --kubeconfig=admin.kubeconfig

{{< / highlight >}}
```

## Distribute configuration files

Copy the appropriate kubeconfig files for `kubelet` and `kube-proxy` to each worker node:

```bash
{{< highlight bash >}}

for instance in node-01 node-02 node-03; do
  scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done

{{< / highlight >}}
```

Copy the appropriate kubeconfig files for `kube-controller-manager` and `kube-scheduler` to each controller:

```bash
{{< highlight bash >}}

for instance in master-1 master-2 master-3; do
  scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done

{{< / highlight >}}
```

Done!

Now you can proceed to [etcd installation](/installation/packages/4etcd).
