---
description: set access, containerum api, default namespace, image, replicas.
draft: false
linktitle: set
menu:
  docs:
    parent: commands
    weight: 5
title: Set
weight: 2

---

#### <a name="set">set</a>

**Description**:

set access, containerum api, default namespace, image, replicas.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[set access](#set_access)** Set namespace access rights. Aliases: namespace-access, ns-access
* **[set containerum-api](#set_containerum-api)** Set Containerum API URL. Aliases: api, current-api, api-addr, API
* **[set default-namespace](#set_default-namespace)** Set default namespace. Aliases: def-ns, default-ns, defns, def-namespace
* **[set image](#set_image)** Set container image for specific deployment.Aliases: imgs, img, im, images
* **[set replicas](#set_replicas)** Set deployment replicas. Aliases: re, rep, repl, replica


#### <a name="set_replicas">set replicas</a>

**Description**:

Set deployment replicas.

**Example**:

chkit set replicas [-n namespace_label] [-d depl_label] [N_replicas]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -d | --deployment | deployment name |  |
| -r | --replicas | replicas, 1..15 | 1 |


**Subcommands**:



#### <a name="set_image">set image</a>

**Description**:

Set container image for specific deployment
If a deployment contains only one container, the command will use that container by default.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --container | container name |  |
|  | --deployment | deployment name |  |
| -f | --force | suppress confirmation | false |
|  | --image | new image |  |


**Subcommands**:



#### <a name="set_default-namespace">set default-namespace</a>

**Description**:

Set default namespace. Aliases: def-ns, default-ns, defns, def-namespace

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:



#### <a name="set_containerum-api">set containerum-api</a>

**Description**:

Set Containerum API URL. Aliases: api, current-api, api-addr, API

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --allow-self-signed-certs |  | false |


**Subcommands**:



#### <a name="set_access">set access</a>

**Description**:

Set namespace access rights.
Available access levels are:
  none
  owner
  read
  read-delete
  write

**Example**:

chkit set access $USERNAME $ACCESS_LEVEL [--namespace $ID]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | suppress confirmation | false |


**Subcommands**:



