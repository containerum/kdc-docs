---
title: Containerum Element
linktitle: Overview
description: Bootstrapping KDC cluster with Containerum Element.


categories: [top]
keywords: []

menu:
  docs:
    parent: "element"
    weight: 1
    identifier: element-overview

draft: false
---

# Containerum Element

Containerum Element is a set of Ansible scripts for bootstrapping a minimum stable Kubernetes cluster. It is based on the certified Kubernetes Distribution by Containerum (read more about KDC at [Containerum website](https://en.containerum.com)).

Containerum Elements installs a Kubernetes cluster with the following components:  
 - **[Kubernetes Distribution by Containerum](https://en.containerum.com)** 1.11.6  
 - **Cri-o** as container runtime  
 - **CoreDNS** as DNS and Service Discovery  
 - **Calico** as container network interface  
 - **Bird** BGP for routing Internet Protocol packets  
 - **Helm** package manager (optional)  

 Containerum Element installs the latest stable versions of the aforementioned components. KDC version is currently 1.11.6.

## Requirements:

 **Local machine**  
 - Ansible >=2.7  

 **Nodes:**  
 - CentOS 7  
 - File system should support OverlayFS  

 Each node should have `centos` user accessible via ssh with permission to execute sudo with no password.

To bootstrap a KDC cluster with Containerum Element proceed to the [installation page](/installation/element/installation).
