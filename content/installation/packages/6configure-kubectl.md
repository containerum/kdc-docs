---
title: Configuring kubectl
linktitle: Configure kubectl
description: Configuring the Kubernetes command line utility `kubectl`

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 7

draft: true
---

# Configure kubectl for remote access

Generate the kubeconfig file for `kubectl` based on `admin` user credentials.

Execute commands from the same directory used to generate the certificates.

### Create the configuration file for admin

Each kubeconfig requires connection to the Kubernetes API Server. To ensure high availability we will use the IP address assigned to the external load balancer.

Generate the kubeconfig file suitable for authenticating the `admin` user:

```bash
{{< highlight bash >}}

kubectl config set-cluster containerum \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_IP}:6443

kubectl config set-credentials admin \
  --client-certificate=admin.crt \
  --client-key=admin.key

kubectl config set-context containerum \
  --cluster=containerum \
  --user=admin

kubectl config use-context containerum

{{< / highlight >}}
```

### Verification
Check the components status. Run:  
```bash
kubectl get componentstatuses
```

Output:

```
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-1               Healthy   {"health":"true"}
etcd-2               Healthy   {"health":"true"}
etcd-0               Healthy   {"health":"true"}
```

Done!

Now you can proceed to [bootstrapping worker nodes](/installation/packages/7bootstrap-workers).
