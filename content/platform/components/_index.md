---
title: Components Overview - Containerum
linktitle: Overview
description:

categories: []
keywords: []

menu:
  docs:
    parent: "components"
    weight: 1
    identifier: platform-overview

draft: false
---

# Overview
Containerum consists of several components:

- api-gateway provides routing for Containerum components
- user-manager is a service for managing users, groups, credentials, blacklists for Containerum
- resource manages Kubernetes namespace objects: deployments, ingresses, etc.
- permissions manage user access to enable teamwork
- kube-api is a set of API for communication between Containerum and K8s
- auth handles user authorization and token management
- mail is a mail server and newsletter template manager
- ui is Web User Interface for Containerum
- [chkit](/cli/) is CLI for Containerum


To install Containerum Platform on-premises, please follow the installation steps for each component. [Begin](/platform/components/api-gateway).
