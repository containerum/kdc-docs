---
title: Kubernetes Smoke Test
linktitle: Smoke test
description: Running a smoke test to make sure the cluster is up and running.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 11

draft: false
---

# Smoke tests

Run a series of tests to ensure the cluster is configured correctly.

## Data encryption

Verify the ability to [encrypt secret data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#verifying-that-data-is-encrypted).

Create a generic secret:

```bash
kubectl create secret generic containerum \
  --from-literal="mykey=mydata"
```

Print a hexdump of the `containerum` secret stored in etcd:

```bash
ssh master-1 \
  --command "sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.crt \
  --cert=/etc/etcd/kubernetes.crt \
  --key=/etc/etcd/kubernetes.key\
  /registry/secrets/default/containerum | hexdump -C"
```

> Output:

```
00000000  2f 72 65 67 69 73 74 72  79 2f 73 65 63 72 65 74  |/registry/secret|
00000010  73 2f 64 65 66 61 75 6c  74 2f 6b 75 62 65 72 6e  |s/default/kubern|
00000020  65 74 65 73 2d 74 68 65  2d 68 61 72 64 2d 77 61  |etes-the-hard-wa|
00000030  79 0a 6b 38 73 3a 65 6e  63 3a 61 65 73 63 62 63  |y.k8s:enc:aescbc|
00000040  3a 76 31 3a 6b 65 79 31  3a 7b 8e 59 78 0f 59 09  |:v1:key1:{.Yx.Y.|
00000050  e2 6a ce cd f4 b6 4e ec  bc 91 aa 87 06 29 39 8d  |.j....N......)9.|
00000060  70 e8 5d c4 b1 66 69 49  60 8f c0 cc 55 d3 69 2b  |p.]..fiI`...U.i+|
00000070  49 bb 0e 7b 90 10 b0 85  5b b1 e2 c6 33 b6 b7 31  |I..{....[...3..1|
00000080  25 99 a1 60 8f 40 a9 e5  55 8c 0f 26 ae 76 dc 5b  |%..`.@..U..&.v.[|
00000090  78 35 f5 3e c1 1e bc 21  bb 30 e2 0c e3 80 1e 33  |x5.>...!.0.....3|
000000a0  90 79 46 6d 23 d8 f9 a2  d7 5d ed 4d 82 2e 9a 5e  |.yFm#....].M...^|
000000b0  5d b6 3c 34 37 51 4b 83  de 99 1a ea 0f 2f 7c 9b  |].<47QK....../|.|
000000c0  46 15 93 aa ba 72 ba b9  bd e1 a3 c0 45 90 b1 de  |F....r......E...|
000000d0  c4 2e c8 d0 94 ec 25 69  7b af 08 34 93 12 3d 1c  |......%i{..4..=.|
000000e0  fd 23 9b ba e8 d1 25 56  f4 0a                    |.#....%V..|
000000ea
```

The etcd key must be prefixed with `k8s:enc:aescbc:v1:key1`, which shows that the `aescbc` provider was used for data encryption with `key1`.

## Deployment tests
Run tests to ensure that deployments are created and managed correctly.

### Preparation for deployment creation

Add the epel-release repository:

```bash
sudo yum install epel-release
```

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

## Untrusted workload

Verify the ability to launch untrusted workload using [gVisor](https://github.com/google/gvisor).

Create an `untrusted` pod:

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: untrusted
  annotations:
    io.kubernetes.cri.untrusted-workload: "true"
spec:
  containers:
    - name: webserver
      image: gcr.io/hightowerlabs/helloworld:2.0.0
EOF
```

### Verification

Verify that the `untrusted` pod is running under gVisor, inspecting the assigned worker node.

Make sure that the `untrusted` pod is running:

```bash
kubectl get pods -o wide
```
> Output:

```
NAME                       READY     STATUS    RESTARTS   AGE       IP           NODE
busybox-68654f944b-djjjb   1/1       Running   0          5m        10.244.0.2   worker-0
nginx-65899c769f-xkfcn     1/1       Running   0          4m        10.244.1.2   worker-1
untrusted                  1/1       Running   0          10s       10.244.0.3   worker-0
```

Request the node where the `untrusted` is running:

```bash
NODE_NAME=$(kubectl get pod untrusted --output=jsonpath='{.spec.nodeName}')
```

SSH to the node:

```bash
ssh ${NODE_NAME}
```

List the containers running under gVisor:

```bash
sudo runsc --root  /run/containerd/runsc/k8s.io list
```

> Output:

```
I0514 14:03:56.108368   14988 x:0] ***************************
I0514 14:03:56.108548   14988 x:0] Args: [runsc --root /run/containerd/runsc/k8s.io list]
I0514 14:03:56.108730   14988 x:0] Git Revision: 08879266fef3a67fac1a77f1ea133c3ac75759dd
I0514 14:03:56.108787   14988 x:0] PID: 14988
I0514 14:03:56.108838   14988 x:0] UID: 0, GID: 0
I0514 14:03:56.108877   14988 x:0] Configuration:
I0514 14:03:56.108912   14988 x:0]              RootDir: /run/containerd/runsc/k8s.io
I0514 14:03:56.109000   14988 x:0]              Platform: ptrace
I0514 14:03:56.109080   14988 x:0]              FileAccess: proxy, overlay: false
I0514 14:03:56.109159   14988 x:0]              Network: sandbox, logging: false
I0514 14:03:56.109238   14988 x:0]              Strace: false, max size: 1024, syscalls: []
I0514 14:03:56.109315   14988 x:0] ***************************
ID                                                                 PID         STATUS      BUNDLE                                                           CREATED                          OWNER
3528c6b270c76858e15e10ede61bd1100b77519e7c9972d51b370d6a3c60adbb   14766       running     /run/containerd/io.containerd.runtime.v1.linux/k8s.io/3528c6b270c76858e15e10ede61bd1100b77519e7c9972d51b370d6a3c60adbb   2018-05-14T14:02:34.302378996Z
7ff747c919c2dcf31e64d7673340885138317c91c7c51ec6302527df680ba981   14716       running     /run/containerd/io.containerd.runtime.v1.linux/k8s.io/7ff747c919c2dcf31e64d7673340885138317c91c7c51ec6302527df680ba981   2018-05-14T14:02:32.159552044Z
I0514 14:03:56.111287   14988 x:0] Exiting with status: 0
```

Get the `untrusted` pod ID:

```bash
POD_ID=$(sudo crictl -r unix:///var/run/containerd/containerd.sock \
  pods --name untrusted -q)
```

Get the `webserver` container ID running in the `untrusted` pod:

```bash
CONTAINER_ID=$(sudo crictl -r unix:///var/run/containerd/containerd.sock \
  ps -p ${POD_ID} -q)
```

Use the gVisor `runsc` command to display the processes running inside the `webserver` container:

```bash
sudo runsc --root /run/containerd/runsc/k8s.io ps ${CONTAINER_ID}
```

> Output:

```
I0514 14:05:16.499237   15096 x:0] ***************************
I0514 14:05:16.499542   15096 x:0] Args: [runsc --root /run/containerd/runsc/k8s.io ps 3528c6b270c76858e15e10ede61bd1100b77519e7c9972d51b370d6a3c60adbb]
I0514 14:05:16.499597   15096 x:0] Git Revision: 08879266fef3a67fac1a77f1ea133c3ac75759dd
I0514 14:05:16.499644   15096 x:0] PID: 15096
I0514 14:05:16.499695   15096 x:0] UID: 0, GID: 0
I0514 14:05:16.499734   15096 x:0] Configuration:
I0514 14:05:16.499769   15096 x:0]              RootDir: /run/containerd/runsc/k8s.io
I0514 14:05:16.499880   15096 x:0]              Platform: ptrace
I0514 14:05:16.499962   15096 x:0]              FileAccess: proxy, overlay: false
I0514 14:05:16.500042   15096 x:0]              Network: sandbox, logging: false
I0514 14:05:16.500120   15096 x:0]              Strace: false, max size: 1024, syscalls: []
I0514 14:05:16.500197   15096 x:0] ***************************
UID       PID       PPID      C         STIME     TIME      CMD
0         1         0         0         14:02     40ms      app
I0514 14:05:16.501354   15096 x:0] Exiting with status: 0
```

You've just bootstrapped a production-ready Kubernetes cluster with Containerum Kubernetes Package. Now you can install [Containerum platform](https://docs.containerum.com/installation/) to manage containerized applications running in Kubernetes.
