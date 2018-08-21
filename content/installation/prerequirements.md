---
title: Requirements
linktitle: Requirements
description: Hardware and environment requirements to Kubernetes nodes.

categories: []
keywords: []

menu:
  docs:
    parent: "kube-installation"
    weight: 2
    identifier: prerequirements

draft: false
---

# Requirements
This section contains hardware and environment requirements to cluster nodes.

## Nodes hardware recommendations

- You can use virtual or physical machines.
- While you can build a cluster with 1 machine, in order to run all the examples and tests you will need at least **3 nodes**.
- Nodes need to run some version of Linux with the x86_64 architecture. It may be possible to run Kubernetes on other OS and architectures, but this guide will use **CentOS**.
- Apiserver and etcd work well on a machine with **2 cores and 2GB RAM** for small and medium cluster. Larger or more active clusters may require more cores.
- Other nodes can have any reasonable amount of resources and are not required to have the same configuration.
- Each node must have a unique hostname.

## etcd hardware recommendations

You will need to run one or more instances of etcd. But it is strongly recommended to run an odd number of etcd instances, because a 3-instance cluster will have quorum while 2 instances are alive, 5 instances will have quorum while 3 instances are alive, 7=>4, etc. Here are just a couple possible options:

- Highly available and easy to recover - Run 3 or 5 etcd instances with their logs written to a directory backed by durable storage (RAID, GCE PD)

- Not highly available, but easy to restore - Run one etcd instance with its log written to a directory backed by durable storage (RAID, GCE PD).

> **Note**: May result in operations outages in case of instance outage.

- Highly available - Run 3 or 5 etcd instances with non durable storage.

> **Note**: Logs can be written to non-durable storage because storage is replicated.


### CPUs

Few etcd deployments require a lot of CPU capacity. Typical clusters need two to four cores to run smoothly.
Heavily loaded etcd deployments, serving thousands of clients or tens of thousands of requests per second, tend to be CPU bound since etcd can serve requests from memory. Such heavy deployments usually need eight to sixteen dedicated cores.


### Memory

etcd has a relatively small memory footprint but its performance still depends on having enough memory. An etcd server will aggressively cache key-value data and spends most of the rest of its memory tracking watchers. Typically 8GB is enough. For heavy deployments with thousands of watchers and millions of keys, allocate 16GB to 64GB memory accordingly.


### Disks

Fast disks are the most critical factor for etcd deployment performance and stability.

A slow disk will increase etcd request latency and potentially hurt cluster stability. Since etcd’s consensus protocol depends on persistently storing metadata to a log, a majority of etcd cluster members must write every request down to disk. Additionally, etcd will also incrementally checkpoint its state to disk so it can truncate this log. If these writes take too long, heartbeats may time out and trigger an election, undermining the stability of the cluster.

etcd is very sensitive to disk write latency. Typically 50 sequential IOPS (e.g., a 7200 RPM disk) is required. For heavily loaded clusters, 500 sequential IOPS (e.g., a typical local SSD or a high performance virtualized block device) is recommended. Note that most cloud providers publish concurrent IOPS rather than sequential IOPS; the published concurrent IOPS can be 10x greater than the sequential IOPS.

etcd requires only modest disk bandwidth but more disk bandwidth buys faster recovery times when a failed member has to catch up with the cluster. Typically 10MB/s will recover 100MB data within 15 seconds. For large clusters, 100MB/s or higher is suggested for recovering 1GB data within 15 seconds.

When possible, back etcd’s storage with a SSD. A SSD usually provides lower write latencies and with less variance than a spinning disk, thus improving the stability and reliability of etcd. If using spinning disk, get the fastest disks possible (15,000 RPM). Using RAID 0 is also an effective way to increase disk speed, for both spinning disks and SSD. With at least three cluster members, mirroring and/or parity variants of RAID are unnecessary; etcd's consistent replication already gets high availability.

### Cluster model
For highly available setups, you will need to decide how to host your etcd cluster. A cluster is composed of at least 3 members. It is recommended to stick to one of the following models:

- Hosting etcd cluster on separate compute nodes (Virtual Machines).
- Hosting etcd cluster on the master nodes.

While the first option provides more performance and better hardware isolation, it is also more expensive and requires an additional support burden.

For **Option 1**: create 3 virtual machines that follow the hardware recommendations. For the sake of simplicity, we will refer to them as `etcd0`, `etcd1` and `etcd2`.

For **Option 2**: you can skip to the next step. Any reference to `etcd0`, `etcd1` and `etcd2` throughout this guide should be replaced with master0, master1 and master2 accordingly, since your master nodes host etcd.

### Hardware configuration examples

- Small cluster - a small cluster serves fewer than 100 clients, fewer than 200 of requests per second, and stores no more than 100MB of data.

- Medium cluster - a medium cluster serves fewer than 500 clients, fewer than 1,000 of requests per second, and stores no more than 500MB of data.

- Large cluster - a large cluster serves fewer than 1,500 clients, fewer than 10,000 of requests per second, and stores no more  than 1GB of data.

- xLarge cluster - an xLarge cluster serves more than 1,500 clients, more than 10,000 of requests per second, and stores more than 1GB data.

**Table with configuration examples:**

| Cluster size | Node amount | vCPUs | Memory (GB) | Max concurrent IOPS | Disk bandwidth (MB/s) |
|----------|--------|-------|--------|------|----------------|
| Small | 50 | 2 | 8 | 3600 | 56.25 |
| Medium | 250 | 4 | 16 | 6000 | 93.75 |
| Large | 1000 | 8 | 32 | 8000 | 125 |
| xLarge | 3000 | 16 | 64 | 16,000 | 250 |

<br>
## CentOS usage

### Disable SELinux
In case of using CentOS it is necessary to disable SELinux.

Open the SELinux `/etc/selinux/config` file and change `SELINUX=` value to `disabled`:

```bash
SELINUX=disabled
```

then reboot:

```bash
$ sudo reboot
```

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

Now you can proceed to Kubernetes installation [using kubeadm](/installation/install_kubeadm/) or [from packages](/installation/packages/).
