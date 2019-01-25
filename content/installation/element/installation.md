---
title: Containerum Element Installation
linktitle: Installation
description: Launching Element to install a KDC cluster.


categories: [top]
keywords: []

menu:
  docs:
    parent: "element"
    weight: 2
    identifier: element-installation

draft: false
---

# Containerum Element  - KDC cluster installation


Fork or download the repo and edit ```/ansible/group_vars/all.yaml``` as follows:
```
cloud_external_ip: xxx.xxx.xxx.xxx #external IP of the master node. In case of using several master nodes a floating IP address must be specified.
k8s_api_external_port: 56443 #port to access the Kubernetes API
cloud_internal_ip: 10.16.0.30 #internal IP address of the master node. In case of using several master nodes, a floating IP address must be specified.
SERVICE_CLUSTER_IP_RANGE: 10.96.0.0/16 #standard Kubernetes subnet. Do not change unless VERY necessary.
SERVICE_NODE_PORT_RANGE: "30000-32767" #port range for Kubernetes services
CLUSTER_CIDR: 192.168.0.0/16 #change only if it overlaps with existing services
KUBELET_RUNTIME: remote
KUBELET_RUNTIME_ENDPOINT: "unix:///var/run/crio/crio.sock"
IP_AUTODETECTION_METHOD_NIC: ens160 #name of the internal network interface on virtual machines
ansible_user: centos #user that has access to all machines and can execute sudo with no password

## settings fs
#dev_master_log: /dev/sdb #name of the disk on the master node for storing logs

#dev_slave_log: /dev/sdb #name of the disk on worker nodes for storing logs
#dev_slave_containers: /dev/sdd #name of the disk on worker nodes for storing container temporary data and images

#dev_etcd_log: /dev/sdb #name of the disk on etcd nodes for storing logs
#dev_etcd_data_etcd: /dev/sdc #name of the disk on etcd nodes for storing etcd data


# CA cert env
cert_ca_country: "EU"
cert_ca_organization: "DEMO_ORG"
cert_ca_organization_unit: "DEMO_UNIT"
cert_ca_locality: "DEMO_LOC"
cert_ca_validity_days: 1024
cert_ca_key_size: 4096

#cert env
cert_cluster_name: "Containerum"
cert_validity_days: 365
cert_key_size: 2048

helm_version: 2.12.1 #Helm Version

```


Edit ```/ansible/group_vars/inventory``` as follows:
```
[masters]
demo-m1 ansible_host=192.0.2.2 - master node's hostname and IP address. Here and below nodes' current hostnames will be overridden with the ones specified in this config file.
#etc

[slaves]
demo-s1 ansible_host=192.0.2.3 - worker1 node's hostname and IP address
demo-s2 ansible_host=192.0.2.4 - worker2 node's hostname and IP address
#etc

[etcd]
demo-m1 ansible_host=192.0.2.2 - etcd1 node's hostname and IP address(same as master)
demo-s1 ansible_host=192.0.2.3 - etcd2 node's hostname and IP address (same as same as worker1)
demo-s2 ansible_host=192.0.2.4 - etcd3 node's hostname and IP address (same as same as worker1)
#etc

[local]
localhost ansible_connection=local
```
## Launch installer
After the variables are set, run:

```
ansible-playbook -i inventory element.yaml
```
Done!

To manage the cluster remotely, install ```kubectl``` locally and copy ```.kube/config``` file from the master node to ```.kube/config``` on your local machine.

## Helm installation
To install Helm, run:

```
ansible-playbook -i inventory deploy-app.yaml --tags "app-helm"
```
To manage the cluster remotely, install ```helm``` locally and copy ```.kube/helm``` from the master node to ```.kube/helm``` on your local machine. Then run helm commands with --tls flag.

## Additional notes
During installation Containerum Elements overrides the following config files on each node:

**/etc/resolv.conf:**

```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
```

**/etc/hosts:**
```
192.0.2.2 demo-m1
192.0.2.3 demo-s1
192.0.2.4 demo-s2
```
The parameters here are drawn from the ```inventory``` file.

**/etc/hostname:**
```
hostname_from_the_inventory_file
```
