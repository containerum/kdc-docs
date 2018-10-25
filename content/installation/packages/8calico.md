---
title: Calico Installation
linktitle: Install Calico
description: Installing Calico - an overlay network for the cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 9

draft: false
---

# Install Calico

Calico is an overlay network for containers. Download the Calico networking manifest:

```bash
curl -O https://raw.githubusercontent.com/containerum/kdc-docs/master/content/files/calico/calico.yaml
```

Now it's time to configure Calico!
To run Calico it needs to be connected to etcd database. We will use same database as Kubernetes do.

At first you need to set up etcd address in `calico.yaml`:

Sure, you can use only one etcd server in this config.
```
etcd_endpoints: "https://${ETCD_NODE_1_IP}:2379,https://${ETCD_NODE_2_IP}:2379,https://${ETCD_NODE_3_IP}:2379"
```
Next uncomment certificate paths in `calico.yaml` ConfigMap:
```
etcd_ca: "/calico-secrets/etcd-ca"
etcd_cert: "/calico-secrets/etcd-cert"
etcd_key: "/calico-secrets/etcd-key"
```
To allow Calico connect to Kubernetes etcd you need add certificates to yaml Secrets section:

You have to encode certificates in base64 removing newlines, you can use this command for ca, key and cert:
```bash
cat ca.crt | base64 -w0
```
Paste output into fields:
```
etcd-key: "<output>"
etcd-cert: "<output>"
etcd-ca: "<output>"
```
If you do not want to use pod-cidr=192.168.0.0/16 then update "CALICO_IPV4POOL_CIDR" value in yaml. Use same CIDR as in other config files.

> **It's also recommended to define default interface for Calico traffic, just add IP_AUTODETECTION_METHOD to env variables in `calico.yaml`.**

# Enable BGP in Calico

If we have everything done right, we need to proceed with BGP configuration in Calico.

First of all, we need to get calicoctl utility, to do this you can add pod to run calicoctl commands:
```bash
curl -O https://raw.githubusercontent.com/containerum/kdc-docs/master/content/files/calico/calicoctl.yaml
```

> Run commands with this syntax:
```bash
kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide
```

```bash
cat << EOF | kubectl exec -ti -n kube-system calicoctl -- /calicoctl create -f -
apiVersion: projectcalico.org/v3
kind: BGPConfiguration
metadata:
  name: default
spec:
  logSeverityScreen: Info
  nodeToNodeMeshEnabled: true
  asNumber: 63400
EOF;
```

To access pods from master you have to install [bird](https://bird.network.cz/) on your master:
```bash
yum install -y bird
```
Bird config sample `/etc/bird.conf`:
```ini
log syslog { trace, info, remote, warning, error, auth, fatal, bug };
log stderr all;

router id 172.16.0.1; # master internal ip

# push all incoming routes to kernel routing table
protocol kernel {
  persist;            # save routes on bird shutdown
  scan time 2;
  export all;         # export all incoming routes to kernel
  graceful restart;
}

# scan interfaces
protocol device {
  debug { states };
  scan time 2;
}

protocol direct {
  debug { states };
  interface "ens160";  # master internal interface
                       # should be the same as configured
                       # for Calico communication
}

# apply incoming routes to pod subnet
filter main_filter {
      if net ~ 192.168.0.0/16 then accept; # use your POD CIDR
      else reject;
}

# BGP rule template
template bgp bgp_template {
  debug { states };
  description "Connection to BGP peer";
  local as 63400;      # same as Calico host AS
  multihop;            # allow connection to neighbor through router
  gateway recursive;   # allow routes through router
  import filter main_filter; # apply filter
  next hop self;       # advertise our ip as next hop
  source address 172.16.0.1; # master internal ip
  add paths on;        # allow multiple routes to same subnet
  graceful restart;
}

# list of BGP peers (kubernetes nodes)
protocol bgp node-01 from bgp_template {
  neighbor 172.16.0.11 as 63400;
}

protocol bgp node-02 from bgp_template {
  neighbor 172.16.0.12 as 63400;
}
```

You have to add master node IP to bgp peers in Calico:
```bash
cat << EOF | kubectl exec -ti -n kube-system calicoctl -- /calicoctl create -f -
apiVersion: projectcalico.org/v3
kind: BGPPeer
metadata:
  name: bgppeer-m1
spec:
  peerIP: 172.16.0.1
  asNumber: 63400
EOF;
```

Done!

Now you can proceed to [configuring DNS](/installation/packages/9dns).
