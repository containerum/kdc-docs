---
title: CLI release notes
linktitle: "CLI"
description: Release notes for chkit CLI.

date: 2018-06-15

categories: ["top"]
keywords: []

menu:
  docs:
    parent: "release-notes"
    weight: 5

weight: 5
draft: false
---


# CLI Release Notes (chkit)

**Latest version: v3.2.0**

_7.06.2018_

Improvements:

    command "update configmap" added
    now using "OWNER/NAMESPACE" or "NAMESPACE" as args in namespace related commands instead of namespace ID
    row enumeration in namespace table added
    remove column separator in tables

Bugs fixed:

    correct build-version forming
    fix crush on "get default-namespace" (invalid chkit initialisation)
