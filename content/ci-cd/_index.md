---
title: CI/CD Overview - Containerum
linktitle: Overview
description: Configuring CI/CD pipelines with Containerum

categories: []
keywords: []

menu:
  docs:
    parent: "ci-cd"
    weight: 1
    identifier: overview-cicd

draft: false
---

# CI/CD Overview
Continuous Integration and Continuous Delivery practices aim at automating delivery processes to allow IT teams release updates incrementally on a regular basis.

**Continuous Integration (CI)** is a practice where codes from different sources are integrated, built and tested automatically using special tools. In case tests fail, the code is further reviewed by developers to resolve conflicts, and in case of success the build is deployed. Code is generally integrated several times into a repository (e.g., GitHub).

**Continuous Delivery (CD)** goes a step further and ensures constant release of deployable updates to see how they work with end users and to respond to market demands much faster.

The deployable unit path in CI/CD is called a pipeline. When code is committed to a remote repository (like GitHub), a build system (like Travis) is notified to start build and run unit tests.

Containerum allows building CI/CD pipelines with chkit CLI. Chkit can be seamlessly integrated with a majority of CI/CD tools like Travis, GitLab, etc. This section covers CI/CD pipeline setup for Travis and GitLab.
