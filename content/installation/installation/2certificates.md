---
title: Kubernetes Certificates
linktitle: Certificates
description: Generation of certificated for etcd, kube-apiserver, kubelet, etc.

categories: []
keywords: []

menu:
  docs:
    parent: "installation"
    weight: 3

draft: false
---

# Certs preparation and generation

 There are two ways to generate certificates - using Containerum script or cfssl.

> **Note**: All steps in this article can be performed on your host machine or on any other machine with the ssh access to all your nodes.

## Option 1: generate certs with Containerum script

Download the script that helps generate and maintain certificate infrastructure sufficient to run a Kubernetes cluster:
```
curl -OL https://raw.githubusercontent.com/containerum/containerum-docs/develop/content/files/gen-kube-ca.sh
chmod +x gen-kube-ca.sh
```

Arguments:

`init` - Initialize a CA and generate default set of certificates.  
`prepare file.conf` - Prepare configuration for generating an extra CSR.  
`prepare file.csr` - Generate an extra certificate signing request.  
`sign file.crt` - Use CA to sign a CSR in file.csr. Result in file.crt.

The script does not remove or overwrite any files with non-zero length - it
completes the file structure to its full state by generating missing files from
the files they are dependent on.

For example, if you put files `admin.key` and `ca.key` into an empty directory, and
call this script from there, it will use `.key` files provided by you for
generation of the CA certificate and `admin.csr` (and consecutively `admin.crt`).
If you want to re-issue a certificate from the same `.csr`, just remove its `.crt`
file and rerun the script.

The `init` subcommand uses IP addresses and DNS names from the environment
variable SAN for the subjectAltName list in kubernetes.crt certificate.

Similarly, the `prepare` subcommand uses environment variables CN, O and SAN
to fill in commonName, organization and subjectAltName fields in the CSR.

### Usage examples

Run this command to generate all default certs:

```
{{< highlight bash >}}
SAN="kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local $HOSTNAME $KUBERNETES_PUBLIC_IP $MASTER_NODES_IP 10.96.0.1 127.0.0.1" ./gen-kube-ca.sh init
{{< / highlight >}}
```

Run this command to create a `.csr` file with desired certificate fields.  
`DOMAIN_NAME` is the hostname for node

```
{{< highlight bash >}}
DOMAIN_NAME=worker-1
CN=system:node:$DOMAIN_NAME O=system:nodes SAN="$INTERNAL_IP $EXTERNAL_IP $DOMAIN_NAME" ./gen-kube-ca.sh prepare $DOMAIN_NAME.csr
{{< / highlight >}}
```

Run this command to sign the certificate:

```
{{< highlight bash >}}
./gen-kube-ca.sh sign worker-1.crt
{{< / highlight >}}
```

### etcd certificate

Don’t forget to generate the certificate for etcd nodes, for example as follows:

```
{{< highlight bash >}}
CN=ETCD O=ETCD SAN="$ETCD_NODE_1_IP $ETCD_NODE_2_IP $ETCD_NODE_3_IP 127.0.0.1" ./gen-kube-ca.sh prepare etcd.csr
./gen-kube-ca.sh sign etcd.crt
{{< / highlight >}}
```


## Option 2: generate certs with cfssl
Create a root certificate with cfssl and generate certificates for etcd, kube-apiserver, kube-controller-manager, kube-scheduler, kubelet, and kube-proxy.

### Installing cfssl and cfssljson

Download and install the binaries from the official repositories:

```
{{< highlight bash >}}
curl -OL https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 -OL https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
{{< / highlight >}}
```

Make sure that cfssl version is 1.2.0 or higher:

```
{{< highlight bash >}}
cfssl version

> Version: 1.2.0
>  Revision: dev
>   Runtime: go1.6
{{< / highlight >}}
```

> **Note**: cfssljson cannot print version to the command line.


### Creating a CA
Create a configuration file and a private key for CA:

```bash
{{< highlight bash >}}

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "Kubernetes",
      "OU": "CA"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

{{< / highlight >}}
```

### Client and server certificates
Create certificates for each Kubernetes component and a client certificate for `admin`:

```bash
{{< highlight bash >}}

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "system:masters",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

{{< / highlight >}}
```

### Generate a certificate for Kube Controller Manager
Generate a certificate:

```bash
{{< highlight bash >}}

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "system:kube-controller-manager",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

{{< / highlight >}}
```

### Generate a certificate for Kube Scheduler
Generate a certificate:

```bash
{{< highlight bash >}}

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "system:kube-scheduler",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

{{< / highlight >}}
```

### Generate a certificate for Kube API Server
To generate a certificate you need to provide a static IP address to the list of domain names for Kubernetes API Server certificates. This will ensure the certificate can be validated by remote clients.

`10.96.0.1` is an IP address of Kubernetes API server instance in Cluster CIDR.

`MASTER_NODES_IP` is a sequence of all IP addresses of master nodes. In the case of one master node, only its IP address should be specified there.

Generate a certificate:

```bash
{{< highlight bash >}}

KUBERNETES_PUBLIC_IP=${PUBLIC_IP}
cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "Kubernetes",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.96.0.1,${MASTER_NODES_IPS},${KUBERNETES_PUBLIC_IP},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

{{< / highlight >}}
```

### Generate a certificate for etcd
To generate a certificate you need to provide a static IP address to the list of domain names for etcd certificates.

`ETCD_NODE_1_IP`, `ETCD_NODE_2_IP`, `ETCD_NODE_3_IP` are IP addresses of instances in the internal network, on which etcd has been installed. They will be used for communication with other cluster peers and to serve client requests.

Generate a certificate:

```bash
{{< highlight bash >}}

cat > etcd-csr.json <<EOF
{
  "CN": "ETCD",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "ETCD",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${ETCD_NODE_1_IP},${ETCD_NODE_2_IP},${ETCD_NODE_3_IP},127.0.0.1 \
  -profile=kubernetes \
  etcd-csr.json | cfssljson -bare etcd

{{< / highlight >}}
```

### The service account key pair

Kubernetes Controller Manager uses a key pair to create and sign tokens for the service account.

Run the script:

```bash
{{< highlight bash >}}

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "Kubernetes",
      "OU": "Сontainerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

{{< / highlight >}}
```

### Generate a certificate for Kubelet clients

Kubernetes uses a special mode of authorization, Node Authorizer, which also authorizes requests from Kubelet to API.
To authorize with Node Authorizer, Kubelet uses the credentials from the `system:nodes` group and the `system:node:${HOSTNAME}` username.
Create a certificate for each node to meet the Node Authorizer requirements.


Script example:

Specify the external and internal IP in `EXTERNAL_IP` and `INTERNAL_IP` correspondingly. If you don't have a private network, you may use only `EXTERNAL_IP`.
${HOSTNAME} is the hostname of the node, for which a certificate is to be generated.

```bash
{{< highlight bash >}}

cat > ${HOSTNAME}-csr.json <<EOF
{
  "CN": "system:node:${HOSTNAME}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "system:nodes",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${HOSTNAME},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${HOSTNAME}-csr.json | cfssljson -bare ${HOSTNAME}

{{< / highlight >}}
```

### Generate a certificate for Kube Proxy
Generate a certificate:

```bash
{{< highlight bash >}}

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "LV",
      "L": "Riga",
      "O": "system:node-proxier",
      "OU": "Containerum"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

{{< / highlight >}}
```

### Distribution of certificates for clients and servers

If you used cfssl to generate the certificates, apply
the traditional naming scheme to the certificate files:

```bash
{{< highlight bash >}}
for f in *-key.pem; do mv -vi "$f" "${f%-key.pem}.key"; done
for f in *.pem; do mv -vi "$f" "${f%.pem}.crt"; done
{{< / highlight >}}
```

Copy the appropriate certificates and the private key to each node:

```bash
{{< highlight bash >}}

for instance in worker-1 worker-2 worker-3; do
  scp ca.crt ${instance}.crt ${instance}.key ${instance}:~/
done

{{< / highlight >}}
```

Copy the appropriate certificates and the private key to each controller:

```bash
{{< highlight bash >}}

for instance in master-1 master-2 master-3; do

  scp ca.crt ca.key kubernetes.key kubernetes.crt \
    service-account.key service-account.crt etcd.key etcd.cert ${instance}:~/

done

{{< / highlight >}}
```

> The kube-proxy, kube-controller-manager, kube-scheduler, and kubelet client certificates will be used to generate client authentication configuration files in the next article.

Done!

Now you can proceed to creating [kubeconfig files](/kubernetes/installation/3kubernetes-configuration-files).
