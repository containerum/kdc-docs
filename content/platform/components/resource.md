---
title: Resource
linktitle: Resource
description: Resource is a service that manages Kubernetes namespace objects in Containerum.

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 7
    identifier: platform-resource


draft: false
---

# Resource

Resource is a service that manages Kubernetes namespace objects (deployments, ingresses, etc.) in Containerum.

### Prerequisites

- Kubernetes

### Installation

Using Helm:

```
  helm repo add containerum https://charts.containerum.io
  helm repo update
  helm install containerum/resource
```

Now you can proceed to [installing the ui component](/platform/components/ui).
