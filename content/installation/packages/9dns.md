---
title: Kubernetes CoreDNS Cluster Add-on
linktitle: DNS Cluster
description: Launching service discovery to applications running inside the Kubernetes cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 10

draft: false
---

# Launch DNS Cluster Add-on
Configure CoreDNS Cluster to enable service discovery for applications running in Kubernetes cluster.

## Deploy the kube-dns cluster add-on


Launch `core-dns`:

```bash
kubectl create -f https://raw.githubusercontent.com/containerum/cdk-docs/master/content/files/coredns.yaml
```  
Output:

```
service "coredns" created
serviceaccount "coredns" created
configmap "coredns" created
deployment.extensions "coredns" created
```

List the pods of the `coredns` deployment:

```bash
kubectl get pods -l k8s-app=kube-dns -n kube-system
```  
Output:

```
NAME                        READY     STATUS    RESTARTS   AGE
coredns-c68859c76-5pw2z     3/3       Running   0          20s
```

## Verification

Create a `busybox` deployment:

```bash
kubectl run busybox --image=busybox --command -- sleep 3600
```

List the pods of the `busybox` deployment:

```bash
kubectl get pods -l run=busybox
```

```
NAME                       READY     STATUS    RESTARTS   AGE
busybox-2125412808-mt2vb   1/1       Running   0          15s
```

Get the full name of the `busybox` pod:

```bash
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
```

Execute a DNS lookup for the `kubernetes` service inside the `busybox` pod:

```bash
kubectl exec -ti $POD_NAME -- nslookup kubernetes.default.svc.cluster.local
```
Output:

```
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
```

Congratulations! You've just bootstrapped your Kubernetes cluster.

Now it's time to [run tests](/installation/packages/10tests) to make sure the cluster is up and running.
