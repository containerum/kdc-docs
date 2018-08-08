---
title: Containerum installation
linktitle: Installation
description: How to install Containerum in Kubernetes cluster.

categories: []
keywords: []

menu:
  docs:
    parent: "platform"
    weight: 2
    identifier: containerum-install

draft: false
---


# Containerum installation

To install Containerum in your Kubernetes Cluster with Containerum configs run:

```
helm repo add containerum https://charts.containerum.io
helm repo update
helm install containerum/containerum
```

This will install the Containerum components and create two Ingresses to expose Containerum. You can view the Ingresses with `kubectl get ingress`.

 To be able to reach Containerum Web UI and the API, add the machine IP address to /etc/hosts, e.g.:

 ```
 127.0.0.1 local.containerum.io api.local.containerum.io
 ```
 where ```127.0.0.1``` is the address of your machine with Containerum.

 Now you can access Containerum Web UI at ```local.containerum.io```. To manage your local Containerum platform via chkit CLI, set the API in chkit:
 ```
 chkit set api api.local.containerum.io
 ```

 Done!

 To launch Containerum platform with custom config files, [install](/platform/components/) each Containerum component in manual mode using Helm. Detailed instructions on custom configuration will be available soon.
