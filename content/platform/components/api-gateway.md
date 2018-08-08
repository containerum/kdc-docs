---
title: Gateway
linktitle: Gateway
description: Gateway is an API service that provides routing for Containerum components.

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 2
    identifier: platform-gateway


draft: false
---

# Gateway
Gateway is an API service that provides routing for Containerum components.

### Prerequisites

- Kubernetes

### Installation

Using Helm:

```
  helm repo add containerum https://charts.containerum.io
  helm repo update
  helm install containerum/api-gateway
  ```

  Now you can proceed to [installing the auth component](/platform/components/auth).
