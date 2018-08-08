---
title: Kube-api
linktitle: Kube-api
description: Kube-api is a set of API for communication between Containerum and Kubernetes.

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 4
    identifier: platform-kube


draft: false
---

# Kube-api

Kube-api is a set of API for communication between Containerum components and Kubernetes.

### Prerequisites

 - Kubernetes

### Installation

Using Helm:

```
  helm repo add containerum https://charts.containerum.io
  helm repo update
  helm install containerum/kube
```
Now you can proceed to [installing the mail component](/platform/components/mail).
