---
title: UI
linktitle: UI
description: Containerum UI project is Web User Interface for Containerum.

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 8
    identifier: platform-ui


draft: false
---

# UI

Containerum UI project is Web User Interface for Containerum.

### Prerequisites

- Kubernetes

### Installation

Using Helm:

```
  helm repo add containerum https://charts.containerum.io
  helm repo update
  helm install containerum/ui
```

Now you can proceed to [installing the user manager component](/platform/components/user-manager).
