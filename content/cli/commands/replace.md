---
description: replace configmap, deployment container, ingress, service.
draft: false
linktitle: replace
menu:
  docs:
    parent: commands
    weight: 5
title: Replace
weight: 2

---

#### <a name="replace">replace</a>

**Description**:

replace configmap, deployment container, ingress, service.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[replace configmap](#replace_configmap)** Replace configmap.Aliases: cm, confmap, conf-map, comap
* **[replace deployment-container](#replace_deployment-container)** Replace deployment container.Aliases: depl-cont, container, dc
* **[replace ingress](#replace_ingress)** Replace ingress.Aliases: ingr, ingresses, ing
* **[replace service](#replace_service)** Replace service.Aliases: srv, services, svc, serv


#### <a name="replace_service">replace service</a>

**Description**:

Replace service.\nRuns in one-line mode, suitable for integration with other tools, and in interactive wizard mode.

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



#### <a name="replace_ingress">replace ingress</a>

**Description**:

Replace ingress with a new one, use --force flag to write one-liner command, omitted attributes are inherited from the previous ingress.

**Example**:

chkit replace ingress $INGRESS [--force] [--service $SERVICE] [--port 80] [--tls-secret letsencrypt]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | suppress confirmation, optional | false |
|  | --host | ingress host (example: prettyblog.io), required |  |
|  | --name | ingress name, optional |  |
|  | --path | path to endpoint (example: /content/pages), optional |  |
|  | --port | ingress endpoint port (example: 80, 443), optional | 0 |
|  | --service | ingress endpoint service, required |  |
|  | --tls-secret | TLS secret string, optional |  |


**Subcommands**:



#### <a name="replace_deployment-container">replace deployment-container</a>

**Description**:

Replace deployment container.
Runs in one-line mode, suitable for integration with other tools, and in interactive wizard mode.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --configmap | container configmap mount, CONFIG:MOUNT_PATH or CONFIG (then MOUNTPATH is /etc/CONFIG) |  |
|  | --container | container name, required on --force |  |
|  | --cpu | container CPU limit, mCPU | 0 |
|  | --delete-configmap | configmap to delete |  |
|  | --delete-env | environment to delete |  |
|  | --delete-volume | volume to delete |  |
|  | --deployment | deployment name, required on --force |  |
|  | --env | container environment variables, NAME:VALUE, 'NAME:$HOST_ENV' or '$HOST_ENV' (to user host env). WARNING: single quotes are required to prevent env from interpolation |  |
| -f | --force | suppress confirmation | false |
|  | --image | container image |  |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --memory | container memory limit, Mb | 0 |
|  | --volume | container volume mounts, VOLUME:MOUNT_PATH or VOLUME (then MOUNT_PATH is /mnt/VOLUME) |  |


**Subcommands**:



#### <a name="replace_configmap">replace configmap</a>

**Description**:

Replace configmap.Aliases: cm, confmap, conf-map, comap

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



