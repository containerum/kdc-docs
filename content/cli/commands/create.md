---
description: create configmap, deployment, deployment container, ingress, service.
draft: false
linktitle: create
menu:
  docs:
    parent: commands
    weight: 5
title: Create
weight: 2

---

#### <a name="create">create</a>

**Description**:

create configmap, deployment, deployment container, ingress, service.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[create configmap](#create_configmap)** create configmap. Aliases: cm, confmap, conf-map, comap
* **[create deployment](#create_deployment)** create deployment. Aliases: depl, deployments, deploy, de, dpl, depls, dep
* **[create deployment-container](#create_deployment-container)** create deployment container. Aliases: depl-cont, container, dc
* **[create ingress](#create_ingress)** create ingress. Aliases: ingr, ingresses, ing
* **[create service](#create_service)** create service. Aliases: srv, services, svc, serv


#### <a name="create_service">create service</a>

**Description**:

Create service.
Service is an object, used by applications for communication with each other within Containerum ecosystem or with external applications. A service can be internal or external.

There are several ways to construct service:
- --file flag, FILE_PATH
- interactive wizard

Use the --force flag to skip wizard

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --deployment | service deployment, required |  |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation, optional | false |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --name | service name, optional |  |
| -o | --output | output format, json/yaml |  |
|  | --port | service port, optional | 0 |
|  | --port-name | service port name, optional |  |
|  | --protocol | service protocol, optional |  |
|  | --target-port | service target port, optional | 0 |


**Subcommands**:



#### <a name="create_ingress">create ingress</a>

**Description**:

Create ingress.
Ingress is an object that controls access to services through DNS. Ingresses can work through http or secure https protocols and support TLS-protocol.

There are several ways to construct ingress:
- --file flag, FILE_PATH
- interactive wizard

Use the --force flag to skip wizard

**Example**:

chkit create ingress [--force] [--filename ingress.json] [-n prettyNamespace]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation, optional | false |
|  | --host | ingress host (example: prettyblog.io), required |  |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --name | ingress name, optional |  |
| -o | --output | output format, json/yaml |  |
|  | --path | path to endpoint (example: /content/pages), optional |  |
|  | --port | ingress endpoint port (example: 80, 443), optional | 0 |
|  | --service | ingress endpoint service, required |  |
|  | --tls-secret | TLS secret string, optional |  |


**Subcommands**:



#### <a name="create_deployment-container">create deployment-container</a>

**Description**:

Add container to deployment container set. Available methods to build deployment:
    - from flags
    - with interactive commandline wizard
    - from yaml ot json file

Use --force flag to create container without interactive wizard.
If the --container-name flag is not specified then wizard generates name RANDOM_COLOR-IMAGE.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --configmap | container configmap mount, CONFIG:MOUNT_PATH or CONFIG (then MOUNTPATH is /etc/CONFIG) |  |
|  | --cpu | container CPU limit, mCPU | 0 |
|  | --deployment | deployment name, required on --force |  |
|  | --env | container environment variables, NAME:VALUE, 'NAME:$HOST_ENV' or '$HOST_ENV' (to user host env). WARNING: single quotes are required to prevent env from interpolation |  |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation | false |
|  | --image | container image |  |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --memory | container memory limit, Mb | 0 |
|  | --name | container name, required on --force |  |
| -o | --output | output format, json/yaml |  |
|  | --volume | container volume mounts, VOLUME:MOUNT_PATH or VOLUME (then MOUNT_PATH is /mnt/VOLUME) |  |


**Subcommands**:



#### <a name="create_deployment">create deployment</a>

**Description**:

Create deployment with containers and replicas.
Available methods to build deployment:
- from flags
- with interactive commandline wizard
- from yaml ot json file

Use --force flag to create container without interactive wizard.

There are several ways to specify the names of containers with flags:
- --container-name flag
- the prefix CONTAINER_NAME@ in the flags --image, --memory, --cpu, --env, --volume

If the --container-name flag is not specified and prefix is not used in any of the flags, then wizard searches for the --image flags without a prefix and generates name RANDOM_COLOR-IMAGE.

If --export-file or --output flag is set in force mode, then deployment will be only exported to local file without any changes on serverside.

**Examples:**

---
**Single container with --container-name**

```bash
> ./ckit create depl \
        --container-name doot \
        --image nginx
```

|        LABEL        | VERSION |  STATUS  |  CONTAINERS  |    AGE    |
| ------------------- | --------| -------- | ------------ | --------- |
| akiraabe-heisenberg |  1.0.0  | inactive | doot [nginx] | undefined |

---
**Single container without --container-name**

```bash
> ./ckit create depl \
        --image nginx
```

|        LABEL        | VERSION |  STATUS  |        CONTAINERS        |    AGE    |
| ------------------- | --------| -------- | ------------------------ | --------- |
|   spiraea-kaufman   |  1.0.0  | inactive | aquamarine-nginx [nginx] | undefined |

---
**Multiple containers with --container-name**


```bash
> ./ckit create depl \
        --container-name gateway \
        --image nginx \
        --image blog@wordpress
```

|        LABEL        | VERSION |  STATUS  |        CONTAINERS        |    AGE    |
| ------------------- | --------| -------- | ------------------------ | --------- |
|   ruckers-fischer   |  1.0.0  | inactive |      gateway [nginx]     | undefined |
|                     |         |          |      blog [wordpress]    |           |

---
**Multiple containers without --container-name**
```bash
> ./ckit create depl \
        --image nginx \
        --image blog@wordpress
```

|        LABEL        | VERSION |  STATUS  |        CONTAINERS        |    AGE    |
| ------------------- | ------- | -------- | ------------------------ | --------- |
|    thisbe-neumann   |  1.0.0  | inactive |      blog [wordpress]    | undefined |
|                     |         |          |    garnet-nginx [nginx]  |           |


**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --configmap | container configmap, CONTAINER_NAME@CONFIGMAP_NAME@MOUNTPATH in case of multiple containers or CONFIGMAP_NAME@MOUNTPATH or CONFIGMAP_NAME in case of one container. If MOUNTPATH is omitted, then /etc/CONFIGMAP_NAME is used as mountpath |  |
|  | --container-name | container name in case of single container |  |
|  | --cpu | container memory limit, mCPU, CONTAINER_NAME@CPU in case of multiple containers or CPU in case of one container |  |
|  | --env | container environment variable, CONTAINER_NAME@KEY:VALUE in case of multiple containers or KEY:VALUE in case of one container |  |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation, optional | false |
|  | --image | container image, CONTAINER_NAME@IMAGE in case of multiple containers or IMAGE in case of one container |  |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --memory | container memory limit, Mb, CONTAINER_NAME@MEMORY in case of multiple containers or MEMORY in case of one container |  |
|  | --name | deployment name, optional |  |
| -o | --output | output format, json/yaml |  |
|  | --replicas | deployment replicas, optional | 0 |
|  | --version | custom deployment semantic version |  |
|  | --volume | container volume, CONTAINER_NAME@VOLUME_NAME@MOUNTPATH in case of multiple containers or VOLUME_NAME@MOUNTPATH or VOLUME_NAME in case of one container. If MOUNTPATH is omitted, then /mnt/VOLUME_NAME isused as mountpath |  |


**Subcommands**:



#### <a name="create_configmap">create configmap</a>

**Description**:

Create configmap.
Configmap is a file storage, which can be mounted into a container. The most common usage of configmap is keeping config files, read-only DB, and secrets. Basically, you can think about it like about very simple key-value storage.

There are several ways to construct configmap:
- --item-string flag, formatted as KEY:VALUE pairs. The VALUE can be token, short init file, etc.
- --item-file flag, KEY:FILE_PATH or FILE_PATH (filename will be used as KEY)
- interactive wizard
- --import-file flag. Fields in imported file must be not base64 encoded!

Use the --force flag to skip wizard

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation, optional | false |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --item-file | configmap file, KEY:FILE_PATH or FILE_PATH |  |
|  | --item-string | configmap item, KEY:VALUE string pair |  |
|  | --name | configmap name, optional |  |
| -o | --output | output format, json/yaml |  |


**Subcommands**:



