---
title: Kubernetes Certificates and Kubeconfigs
linktitle: Generate certificates
description: Generation of certificates and kubeconfigs for etcd, kube-apiserver, kubelet, etc.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 3

draft: false
---

# Certs preparation and generation

This section describes how to generate Kubernetes certificates with cert-machine.

> **Note**: All steps in this article can be performed on your host machine or on any other machine with the ssh access to all of your nodes.

## Generate certificates with cert-machine

Download and build cert-machine that helps generate and maintain certificate infrastructure sufficient to run a Kubernetes cluster:
```bash
{{< highlight bash >}}

git clone https://github.com/nkmazur/cert_machine.git
cargo install
export PATH=$PATH:$HOME/.cargo/bin

{{< / highlight >}}
```

Config file `config.toml`:

```toml
cluster_name = "Test kubernetes cluster"  # Common name for certificate authority
validity_days = 365  # Validity in days for non CA certificates
master_san = ["10.96.0.1", "192.0.2.1", "172.16.0.1", "172.16.0.2", "172.16.0.3", "m1-test", "m2-test", "m3-test"]  # SAN for kube-apiserver certificate
apiserver_internal_address = "192.0.2.1:6443"  # Apiserver address which will be writen in all kubeconfig files exclude admin.kubeconfig
apiserver_external_address = "192.0.2.1:6443"  # Apiserver address which will be writen in admin and user kubeconfigs

[[worker]]  # Worker node section
hostname = "node-01" # Hostname of worker node
san = ["172.16.0.11", "node-01"]  # SAN for kubelet server certificate

[[worker]]
hostname = "node-02"
san = ["172.16.0.12", "node-02"]

[[etcd_server]]  # Etcd node section
hostname = "etcd1"  # Hostname of etcd node
san = ["172.16.1.5", "etcd1"]  # SAN for etcd server and peer certificate

[[etcd_server]]
hostname = "etcd2"
san = ["172.16.1.6", "etcd2"]

[[etcd_server]]
hostname = "etcd3"
san = ["172.16.1.7", "etcd3"]

[ca]  # Certificate authority section
country = "LV"  # Country code can be presented in main CA cert. Optional
organization = "Exon LV"  # Organization name can be presented in main CA cert. Optional
organization_unit = "Kubernetes Ops"  # Organization unit can be presented in main CA cert. Optional
locality = "Riga"  # Locality can be presented in main CA cert. Optional
validity_days = 1000  # Validity in days for all CA certs
```

### Usage:

`new` - Create new CA.
`gen-cert` - Create single certificate.

Cert-machine does not remove or overwrite any files. Instead it creates symlinks to files in the CA directory.



The `new` subcommand generates a new certificate authority and signed certificates, using information about cluster from the `config.toml` file.
The `gen-cert` subcommand generates TLS certificates and kubeconig for node.

### Example

To generate a valid certificates range create a valid config like the one described below and run following commands:

```
{{< highlight bash >}}
cert-machine new
Creating CA with name: Test kubernetes cluster
Create CA: etcd
Create CA: front proxy
Creating cert for Kubernetes admin
Creating cert for Kubernetes API server
Creating cert for Kubernetes API server kubelet client
Creating cert for Kubernetes ETCD client
Creating cert for Kubernetes controller-manager
Creating cert for Kubernetes scheduler
Creating cert for front-proxy-client
Creating cert for Kubernetes proxy
Creating cert for node: node-01
Creating server cert for node: node-01
Creating cert for node: node-02
Creating server cert for node: node-02
Creating cert for etcd node: etcd1
Creating cert for etcd node: etcd2
Creating cert for etcd node: etcd3
{{< / highlight >}}
```

## Distribute configuration files

Distribute certificates and kubeconifgs across the nodes:
```bash
for instance in node-01 node-02 node-03; do
  scp -r ${instance} ${instance}:~/
done
```

Copy the master files to each controller:

```bash
{{< highlight bash >}}

for instance in master-1 master-2 master-3; do
  scp -r master/ ${instance}:~/
done

{{< / highlight >}}
```

Done!

Now you can proceed to [etcd installation](/installation/packages/4etcd).
