---
title: Containerum Distribution of Kubernetes - Installation
linktitle: Overview
description: Installing Containerum Distribution of Kubernetes using Kubeadm or from packages.

categories: [top]
keywords: []

menu:
  docs:
    parent: "kube-installation"
    weight: 1
    identifier: kubernetes-overview

draft: false
---

# Containerum Distribution of Kubernetes
This section describes how to bootstrap a high availability cluster with Containerum Distribution of Kubernetes.
Containerum Distribution of Kubernetes is a production-grade upstream Kubernetes distribution. It has been tested and is guaranteed to work on any infrastructure.   

Containerum Distribution of Kubernetes can bootstrapped from packages or you can use Kubeadm for a quick installation in Docker.

Containerum Distribution of Kubernetes installed from packages relies on containerd runtime. Containerd installation is also covered in this guide.

Make sure that your VMs meet the [requirements](/installation/prerequirements) and then proceed to installation instructions - [using kubeadm](/installation/install_kubeadm/) or [from packages](/installation/packages/).
