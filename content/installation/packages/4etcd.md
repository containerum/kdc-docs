---
title: Kubernetes ETCD Installation
linktitle: Etcd
description: Installing and configuring the etcd cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 5

draft: false
---

# Bootstrapping the etcd cluster
This section covers how to launch a 3-node etcd cluster, configure high availability, and secure remote access.

## Bootstrapping an etcd Cluster Member
> **Run each command from this section on each instance that you would like to use as an etcd node**.

As described in the [requirements](/kubernetes/prerequirements/) section, you can install etcd on either master node instances or separate node instances.

Login to each instance via ssh.

### Install the etcd package

To install etcd from the official repo run:
```bash
{{< highlight bash >}}

sudo yum install etcd

{{< / highlight >}}
```

### Configure the etcd server

Run:
```bash
{{< highlight bash >}}

sudo cp ca.crt etcd.crt etcd.key /etc/ssl/etcd/
sudo chown etcd:etcd /etc/ssl/etcd/*.key /etc/ssl/etcd/*.crt
sudo chmod 640 /etc/ssl/etcd/*.key

{{< / highlight >}}
```

`ETCD_NODE_1_IP`, `ETCD_NODE_2_IP`, `ETCD_NODE_3_IP` are IP addresses of instances in the internal network, on which etcd has been installed. They will be used to communicate with other cluster peers and serve client requests.  
In the case of etcd installation to master nodes `ETCD_NODE_1_IP` is equal to `MASTER_1_INTERNAL_IP` and so on.
`INTERNAL_IP` is the IP address of current instance in the internal network.

Each etcd node must have a unique name within the cluster. Set the etcd node name to match the current node host name.

```bash
ETCD_NAME=$(hostname -s)
```

Edit the etcd config file in `/etc/etcd/etcd.conf`. You should uncomment the lines below and replace their value with the variables retrieved above:
```
cat <<EOF > /etc/etcd/etcd.conf
ETCD_LISTEN_PEER_URLS="https://${INTERNAL_IP}:2380"
ETCD_LISTEN_CLIENT_URLS="https://127.0.0.1:2379,https://${INTERNAL_IP}:2379"
ETCD_NAME=${ETCD_NAME}
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${INTERNAL_IP}:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://${INTERNAL_IP}:2379"
ETCD_INITIAL_CLUSTER="master-1=https://${ETCD_NODE_1_IP}:2380,master-2=https://${ETCD_NODE_2_IP}:2380,master-3=https://${ETCD_NODE_3_IP}:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-1"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_CERT_FILE="/etc/ssl/etcd/etcd.crt"
ETCD_KEY_FILE="/etc/ssl/etcd/etcd.key"
ETCD_TRUSTED_CA_FILE="/etc/ssl/etcd/ca.crt"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_PEER_CERT_FILE="/etc/ssl/etcd/etcd.crt"
ETCD_PEER_KEY_FILE="/etc/ssl/etcd/etcd.key"
ETCD_PEER_CLIENT_CERT_AUTH="true"
ETCD_PEER_TRUSTED_CA_FILE="/etc/ssl/etcd/ca.crt"
EOF
```

> **Note**: In the case of one etcd node these variables are not required:
> - `ETCD_LISTEN_PEER_URLS`
> - `ETCD_INITIAL_ADVERTISE_PEER_URLS`
> - `ETCD_INITIAL_CLUSTER`
> - `ETCD_PEER_CERT_FILE`
> - `ETCD_PEER_KEY_FILE`
> - `ETCD_PEER_CLIENT_CERT_AUTH`
> - `ETCD_PEER_TRUSTED_CA_FILE`

### Launch the etcd server

Run:

```bash
{{< highlight bash >}}

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

{{< / highlight >}}
```

## Verification
List the etcd cluster member(s):

```bash
{{< highlight bash >}}

sudo ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/ssl/etcd/ca.crt \
  --cert=/etc/ssl/etcd/etcd.crt \
  --key=/etc/ssl/etcd/etcd.key

{{< / highlight >}}
```

> Output:

```
3471148b2d70b86c, started, master-2, https://172.16.150.2:2380, https://172.16.150.2:2379
b4214d8293e72630, started, master-3, https://172.16.150.3:2380, https://172.16.150.3:2379
f6fc911b19984e4c, started, master-1, https://172.16.150.1:2380, https://172.16.150.1:2379
```

Done!

Now you can proceed to [bootstrapping Kubernetes controllers](/installation/packages/5bootstrap-controllers).
