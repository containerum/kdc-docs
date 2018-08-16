---
title: Kubeconfig files
linktitle: Kubeconfig
description: Creating Kubernetes authentication configuration files.

categories: []
keywords: []

menu:
  docs:
    parent: "installation"
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

Specify the `containerum` static IP address:

```bash
KUBERNETES_PUBLIC_IP=${PUBLIC_IP}
```

### Create a kubelet configuration file

When generating kubeconfig for Kubelets, a client certificate matching the Kubelet's node hostname must be used (`worker-1 worker-2 worker-3` in the example below). This will ensure Kubelets are properly authorized by the Kubernetes Node Authorizer.

Create a kubeconfig file for each worker:

```bash
{{< highlight bash >}}

for instance in worker-1 worker-2 worker-3; do
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

for instance in worker-1 worker-2 worker-3; do
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

## Create a configuration file for data and key encryption

Kubernetes stores data about cluster state, application configuration and secrets. Kubernetes supports encrypting all cluster data.

### Encryption key

Create an encryption key:

```bash
{{< highlight bash >}}
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
{{< / highlight >}}
```

### Configuration file

>**Warning**: This part is not required. Secrets encryption is an experimental feature in Kubernetes. You may use it only at your own risk.

Create `encryption-config.yaml` as follows:

```yaml
{{< highlight yaml >}}

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

{{< / highlight >}}
```

Copy `encryption-config.yaml` to each master:

```bash
{{< highlight bash >}}

for instance in master-1 master-2 master-3; do
  scp encryption-config.yaml ${instance}:~/
done

{{< / highlight >}}
```

Done!

Now you can proceed to [etcd installation](/kubernetes/installation/4etcd).
