---
title: Kubernetes prerequisites
linktitle: Prerequisites
description: Kubernetes can be deployed on any virtual or hardware environment.

categories: []
keywords: []

menu:
  docs:
    parent: "kube-installation"
    weight: 3

draft: true
---

# Kubernetes prerequisites
Before installing Kubernetes make sure you have the following components:

- CentOS 7
- Docker-1.13

## How to Install Docker
Install Docker 1.13 on CentOS 7

Official Kubernetes docs say that version 17.03 is recommended, but 1.11, 1.12 and 1.13 are known to work as well (and are easier to install). You can install them from standard CentOS 7 repositories.

Run:
```
$ sudo yum install docker
```

After installation it is necessary to disable SELinux: change ```SELINUX=enabled``` to ```SELINUX=disabled``` in ```/etc/selinux/config```.
Reboot, add docker to autostart and launch it with:

```
$ sudo systemctl enable docker && systemctl start docker
```
Done!

<!--
## How to Install etcd
Standard CentOS 7 repositories contain etcd v. 3.2.18.

Run:
```
 $ sudo yum install etcd
 ```

To encrypt the traffic between etcd nodes it is necessary to generate self-signed certificates. Create directory ```/etc/ssl/etcd/``` and create openssl.cnf in this catalogue:

```
openssl.cnf:
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
IP.2 = <node_ip>
```

In [alt_names] add IP-address for each node, e.g.:
IP.1 = 127.0.0.1
IP.2 = 127.0.0.2
IP.3 = 127.0.0.3

Then generate the certificates. Generate the CA certificate:

```
$ openssl genrsa -out ca-key.pem 2048
$ openssl req -x509 -new -nodes -key ca-key.pem -days 365 -out ca.pem -subj "/CN=etcd-ca"
```

Generate certificates for etcd:
```
$ openssl genrsa -out etcd-key.pem 2048
$ openssl req -new -key etcd-key.pem -out etcd.csr -subj "/CN=etcd" -config openssl.cnf
$ openssl x509 -req -in etcd.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out etcd.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

Generate certificates for etcd clients:

```
$ openssl genrsa -out etcd-client-key.pem 2048
$ openssl req -new -key etcd-client-key.pem -out etcd-client.csr -subj "/CN=etcd-client" -config openssl.cnf
$ openssl x509 -req -in etcd-client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out etcd-client.pem -days 365 -extensions v3_req -extfile openssl.cnf
```

Edit etcd config file. Open ```/etc/etcd/etcd.conf``` and change it as follows:

```
ETCD_NAME="node1"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://127.0.0.1:2380"
ETCD_LISTEN_PEER_URLS="https://127.0.0.1:2380"
ETCD_LISTEN_CLIENT_URLS="https://127.0.0.1:2379,https://127.0.0.1:2379"
ETCD_ADVERTISE_CLIENT_URLS="https://127.0.0.1:2379"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-1"
ETCD_INITIAL_CLUSTER="node1=https://127.0.0.1:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_CERT_FILE="/etc/ssl/etcd/etcd-client.pem"
ETCD_KEY_FILE="/etc/ssl/etcd/etcd-client-key.pem"
ETCD_PEER_CERT_FILE="/etc/ssl/etcd/etcd.pem"
ETCD_PEER_KEY_FILE="/etc/ssl/etcd/etcd-key.pem"
ETCD_PEER_CLIENT_CERT_AUTH="true"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_TRUSTED_CA_FILE="/etc/ssl/etcd/ca.pem"
ETCD_PEER_TRUSTED_CA_FILE="/etc/ssl/etcd/ca.pem"
```

Now run etcd:

```
$ sudo systemctl start etcd
```

Done!
-->

Now you can proceed to [Kubernetes installation](/kubernetes/installation/1intro).
