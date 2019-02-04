---
title: Bootstrapping Controllers
linktitle: Bootstrap Controllers
description: Bootstrapping Kubernetes Control Plane and configuring high availability.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 6

draft: false
---

# Launch Kubernetes Control Plane

The following components should be installed on each master node: Kubernetes API Server, Scheduler, and Controller Manager.

> **Don't forget to run all commands on all master nodes.**

> **Note**: In the case of launching on one host `PUBLIC_KUBERNETES_IP`  (IP address of kubernetes load balancer) can be replaced with `MASTER_IP`

### Install Kubernetes master node meta-package

Run:

```bash
{{< highlight bash >}}

sudo yum install kubernetes-master-meta

{{< / highlight >}}
```

### Copy certs and kubeconfigs to appropriate directories

```bash
{{< highlight bash >}}

cd master
sudo cp *.{crt,key,pub} /etc/kubernetes/pki/
sudo cp *.kubeconfig /etc/kubernetes/
chmod 600 /etc/kubernetes/pki/*.key
chmod 600 /etc/kubernetes/*.kubeconfig

{{< / highlight >}}
```

### Configure the Kubernetes API Server

Check the default kube-apiserver.service systemd unit with `systemctl cat kube-apiserver.service`.
If you know the default flags don’t match your setup, copy the unit into `/etc/systemd/system/kube-apiserver.service` and make your changes there.

Otherwise, just update the `/etc/sysconfig/kube-apiserver` file with appropriate IP addresses.

The node internal IP address will be used to manifest the API server as a cluster member. It must be set in `ADVERTISE_ADDRESS` variable.

```
ADVERTISE_ADDRESS=192.0.2.1
BIND_ADDRESS=0.0.0.0
ETCD_SERVERS=https://${ETCD_NODE_1_IP}:2379,https://${ETCD_NODE_2_IP}:2379,https://${ETCD_NODE_3_IP}:2379
```

### Configure Kubernetes Controller Manager

Modify the default values in `/etc/sysconfig/kube-controller-manager`:  

```
BIND_ADDRESS=0.0.0.0
```

### Launch Controller Services
Run:

```bash
{{< highlight bash >}}

sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler kubernetes.target
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler kubernetes.target

{{< / highlight >}}
```

> It can take about 10 seconds or more to initialize the Kubernetes API Server.

### Enable HTTP Health Checks (optional)

Network Load Balancer supports only HTTP health checks, HTTPS is not supported. This can be fixed with nginx which will serve as a proxy. Install and configure nginx to accept health checks on port 80 and proxy the request to `https://127.0.0.1:6443/healthz`.

> The `/healthz` endpoint doesn't require authorization.

### Verification
Check the components status. Run:

```bash
{{< highlight bash >}}

kubectl get componentstatuses --kubeconfig admin.kubeconfig

{{< / highlight >}}
```

> Output:

```
NAME                 STATUS    MESSAGE              ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-2               Healthy   {"health": "true"}
etcd-0               Healthy   {"health": "true"}
etcd-1               Healthy   {"health": "true"}
```

> Don't forget to run all commands on each node.

## RBAC for Kubelet Authorization

Configure RBAC permissions that will allow Kubernetes API Server to access Kubelet API on each worker node. Access to Kubelet API is required to get metrics, logs, and to execute commands in pods.

Create `system:kube-apiserver-to-kubelet` [ClusterRole](https://kubernetes.io/docs/admin/authorization/rbac/#role-and-clusterrole), allow access to Kubelet API and execute the key tasks associated with pods management:

```bash
{{< highlight bash >}}

cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

{{< / highlight >}}
```

Kubernetes API authenticates to kubelet as `kubernetes` user, using the client certificate defined by the `--kubelet-client-certificate` flag.

Bind the `system:kube-apiserver-to-kubelet` ClusterRole for the `kubernetes` user:

```bash
{{< highlight bash >}}

cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF

{{< / highlight >}}
```

## Configure kubectl

To configure kubectl just copy admin config to ~/.kube/config:

```bash
{{< highlight bash >}}

cp users/admin.kubeconfig ~/.kube/config

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
