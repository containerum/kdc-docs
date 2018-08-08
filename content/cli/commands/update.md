---
description: |-
  Update chkit from github or local filesystem.

  Just run

  ```bash
  > chkit update
  ```
draft: false
linktitle: update
menu:
  docs:
    parent: commands
    weight: 5
title: Update
weight: 2

---

#### <a name="update">update</a>

**Description**:

Update chkit from github or local filesystem.

Just run

```bash
> chkit update
```

**Example**:

chkit update [from github|dir <path>] [--debug]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --debug | print debug information | false |


**Subcommands**:

* **[update from](#update_from)** from dir, github.


#### <a name="update_from">update from</a>

**Description**:

from dir, github.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[update from dir](#update_from_dir)** update from local directory
* **[update from github](#update_from_github)** update from github releases


