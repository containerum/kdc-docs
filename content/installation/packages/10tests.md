---
title: Kubernetes Cluster Tests
linktitle: Tests
description: Running a tests to make sure the cluster is up and running.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 11

draft: false
---

# Tests

Run a series of tests to ensure the cluster is configured correctly.

## Deployment tests
Run tests to ensure that deployments are created and managed correctly.

### Preparation for deployment creation

Disable SELinux Policy in the `/etc/selinux/config` file. Change it as follows:

```bash
SELINUX=disabled
```
Then reboot the instance to apply changes.

### Test the ability to create and manage deployments

Create an nginx deployment:

```bash
kubectl run nginx --image=nginx
```

List the pods of the `nginx` deployment:

```bash
kubectl get pods -l run=nginx
```

> Output:

```
NAME                     READY     STATUS    RESTARTS   AGE
nginx-65899c769f-xkfcn   1/1       Running   0          15s
```

### Port forwarding
Verify the ability to get remote access to applications.

Get the full name of the `nginx` pod:

```bash
POD_NAME=$(kubectl get pods -l run=nginx -o jsonpath="{.items[0].metadata.name}")
```

Forward the port `8080` on the local machine to the port `80` of the nginx pod:

```bash
kubectl port-forward $POD_NAME 8080:80
```

> Output:

```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

Send an HTTP request to the forwarded address in a new terminal:

```bash
curl --head http://127.0.0.1:8080
```

> Output:

```
HTTP/1.1 200 OK
Server: nginx/1.13.12
Date: Mon, 14 May 2018 13:59:21 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Mon, 09 Apr 2018 16:01:09 GMT
Connection: keep-alive
ETag: "5acb8e45-264"
Accept-Ranges: bytes
```

Return to the previous terminal and stop port forwarding from the nginx pod:

```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
^C
```

### Logs

Get the logs for the `nginx` pod:

```bash
kubectl logs $POD_NAME
```

> Output:

```
127.0.0.1 - - [14/May/2018:13:59:21 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.52.1" "-"
```

### Command execution inside pods

Print the nginx version with the command `nginx -v` in `nginx` container:

```bash
kubectl exec -ti $POD_NAME -- nginx -v
```

> Output:

```
nginx version: nginx/1.13.12
```

## Services

Verify the ability to retrieve [services](https://kubernetes.io/docs/concepts/services-networking/service/).

Expose the `nginx` deployment with [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport):

```bash
kubectl expose deployment nginx --port 80 --type NodePort
```

Print the port assigned to the `nginx` service:

```bash
NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')
```

Make an HTTP request to the external IP and the `nginx` port:

```bash
curl -I http://${EXTERNAL_IP}:${NODE_PORT}
```

> Output:

```
HTTP/1.1 200 OK
Server: nginx/1.13.12
Date: Mon, 14 May 2018 14:01:30 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Mon, 09 Apr 2018 16:01:09 GMT
Connection: keep-alive
ETag: "5acb8e45-264"
Accept-Ranges: bytes
```

You have bootstrapped and tested a production-ready Kubernetes cluster with Containerum Kubernetes Package. Now you can install [Containerum platform](https://docs.containerum.com/installation/) to manage containerized applications running in Kubernetes.
