---
title: Permissions
linktitle: Permissions
description: Permissions is a service for Containerum that manages user access and enables teamwork.

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 6
    identifier: platform-permissions


draft: false
---

# Permissions

Permissions is a service for Containerum that manages user access and enables teamwork.

### Prerequisites

- Kubernetes

### Installation

Using Helm:

```
  helm repo add containerum https://charts.containerum.io
  helm repo update
  helm install containerum/permissions
  ```
Now you can proceed to [installing the resource component](/platform/components/resource).
