---
title: Kubernetes Certificates
linktitle: Generate certificates
description: Generation of certificates for etcd, kube-apiserver, kubelet, etc.

categories: []
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 3

draft: false
---

# Certs preparation and generation

This section describes how to generate Kubernetes certificates with Containerum kube-cert-generator.

> **Note**: All steps in this article can be performed on your host machine or on any other machine with the ssh access to all of your nodes.

## Generate certificates with Containerum kube-cert-generator

Download and build the script that helps generate and maintain certificate infrastructure sufficient to run a Kubernetes cluster:
```bash
{{< highlight bash >}}

mkdir -p cert
cd cert
curl -OL https://github.com/containerum/kube-cert-generator/releases/download/v1.0.4/kube-cert-generator_linux_amd64_v1.0.4.tar.gz
tar xvf kube-cert-generator_linux_amd64_*.tar.gz
mv ca generator
chmod +x generator
rm -rfv kube-cert-generator_linux_amd64_*.tar.gz

{{< / highlight >}}
```

Config file `config.toml`:
```
overwrite_files = false  # If "true" overwrite exsisting files.

validity_period = "24h" # default cert validity priod for all certificates.
key_size = 2048 # RSA key size for all certs.

[common_fields] # default parameters for all certs
common_name = "Sample Cert"
country = ["RU"]
organization = ["org"]
organization_unit = ["ou"]
locality = []
province = []
street_address = []
postal_code = []

[master_node] # certificate for kubernetes control plane
alias = "master"
addresses = ["10.96.0.1", "192.0.2.1", "192.168.0.1", "192.168.0.2", "192.168.0.3"] # SAN for apiserver. Must contain all apiserver private addresses, public address (or public load balancer addr.) and cluster ip (10.96.0.1 here).

[[worker_node]] # certificates for worker node
alias = "node-01" # must be same as hostname of node.
addresses = ["node-01", "192.168.0.11"] # internal ip addr and hostname of node

[[worker_node]]
alias = "node-02"
addresses = ["node-02", "192.168.0.12"]

[[etcd_node]] # certificates for etcd
alias = "etcd1" # filename of etcd cert
addresses = ["ectd1", "192.168.1.5"] # SAN for etcd

[[etcd_node]]
alias = "etcd2"
addresses = ["ectd2", "192.168.1.6"]

[[extra_cert]] # you can generate some custom cert
name = "custom_cert"
common_name = "custom.example.com"
country = ["RU"]
organization = ["org"]
organization_unit = ["ou"]
locality = []
province = []
street_address = []
postal_code = []
validity_period = "24h"
key_size = 2048

  [extra_cert.host] # SANs for custom cert
  alias = "etcd2"
  addresses = ["custom.example.com", "127.0.0.1", "192.168.0.111"]

[ca] # certificate authority configuration
root_dir = "cert"
common_name = "Sample Cert"
country = ["RU"]
organization = ["org"]
organization_unit = ["ou"]
locality = []
province = []
street_address = []
postal_code = []
validity_period = "24h"
key_size = 2048
```

Arguments:

`init-ca` - Initialize a CA.  
`gen-csr` - Prepare configuration for generating a CSRs.  
`sign file.crt` - Use CA to sign a CSR in file.csr. Result in file.crt.

The script does not remove or overwrite any files with non-zero length - it completes the file structure to its full state by generating missing files from the files they are dependent on.

For example, if you put files `admin.key` and `etcd1.key` into an empty directory, and call this script from there, it will use `.key` files provided by you for generation of the CA certificate and `admin.csr` (and consecutively `admin.crt`). If you want to re-issue a certificate, just remove its `.cey`, `.csr` and `.crt` files and rerun the script.

The `init-ca` subcommand creates a new certificate authority from the `[ca]` template in `config.toml` file.
The `gen-csr` subcommand generates a certificate signing requests for all services, using IP addresses and DNS names from the `config.toml` file.
The `sign` subcommand signs CSR with CA key.

### Usage examples

To generate a valid certificates range create a valid config like the one described below and run following commands:

```
{{< highlight bash >}}
./generator init-ca
./generator gen-csr
./generator sign cert/*.csr
cp cert/root/certs/root.crt cert/ca.crt
cp cert/root/keys/root.key cert/ca.key
{{< / highlight >}}
```

Done! You have generated a full certificate bundle for Kubernetes infrastructure.

Now you can proceed to creating [kubeconfig files](/installation/packages/3kubernetes-configuration-files).
