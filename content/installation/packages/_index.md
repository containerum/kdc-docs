---
title: KDC Installation
linktitle: Overview
description: Bootstrapping Kubernetes Distribution by Containerum from packages.

categories: [top]
keywords: []

menu:
  docs:
    parent: "packages"
    weight: 1
    identifier: kube-inst-overview

draft: false
---

# Kubernetes installation overview

This section covers installation of a production-ready Kubernetes cluster from packages with Kubernetes Distribution by Containerum. To set up a high availability Kubernetes cluster follow the instructions in this section step-by-step.

- Check out the variables  
Read through the list of the variables that will be used throughout the installation process.

- Configure certificates  
Generating certificates for certain IP addresses, nodes, hostnames, etc. Certificates are needed for traffic encryption.

- Configure authentication files for Kubernetes components  
Authentication files are required for communication between Kubernetes components.

- Bootstrap etcd  
Etcd is a key-value store where Kubernetes stores cluster state information.

- Bootstrap controllers  
Launching a master node (Kubernetes Control Plane) and configuring high availability. It also demonstrates how to create an external load balancer to expose Kubernetes API for remote clients in the external network.

- Configure kubectl  
Kubectl is a CLI tool for Kubernetes.

- Bootstrap workers  
Launching worker nodes. You can launch as many workers as you need.

- Install flannel  
Flannel is a virtual network that attaches IP addresses to containers.

- Configure DNS add-on  
[DNS add-on](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) is a DNS-based service discovery to applications running in the Kubernetes cluster.

- run tests  
This section describes how to run a full set of tests to make sure that the Kubernetes cluster functions correctly.

Begin [Kubernetes installation](/installation/packages/1intro).
