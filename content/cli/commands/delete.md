---
description: delete configmap, deployment, deployment container, deployment version,
  ingress, namespace, pod, service, solution.
draft: false
linktitle: delete
menu:
  docs:
    parent: commands
    weight: 5
title: Delete
weight: 2

---

#### <a name="delete">delete</a>

**Description**:

delete configmap, deployment, deployment container, deployment version, ingress, namespace, pod, service, solution.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[delete configmap](#delete_configmap)** delete configmap. Aliases: cm, confmap, conf-map, comap
* **[delete deployment](#delete_deployment)** delete deployment in specific namespace. Aliases: depl, deployments, deploy, de, dpl, depls, dep
* **[delete deployment-container](#delete_deployment-container)** delete container. Aliases: depl-cont, container, dc
* **[delete deployment-version](#delete_deployment-version)** delete inactive deployment version. Aliases: depl-version, devers, deploy-vers, depver, deplver
* **[delete ingress](#delete_ingress)** delete ingress. Aliases: ingr, ingresses, ing
* **[delete namespace](#delete_namespace)** delete namespace. Aliases: ns, namespaces
* **[delete pod](#delete_pod)** delete pod in specific namespace. Aliases: po, pods
* **[delete service](#delete_service)** delete service in specific namespace. Aliases: srv, services, svc, serv
* **[delete solution](#delete_solution)** Delete running solution. Aliases: sol, solutions, sols, solu, so


#### <a name="delete_solution">delete solution</a>

**Description**:

Delete running solution. Aliases: sol, solutions, sols, solu, so

**Example**:

chkit delete solution [--force]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | delete solution without confirmation | false |


**Subcommands**:



#### <a name="delete_service">delete service</a>

**Description**:

Delete service in namespace.

**Example**:

chkit delete service service_label [-n namespace]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | force delete without confirmation | false |


**Subcommands**:



#### <a name="delete_pod">delete pod</a>

**Description**:

Delete pods.

**Example**:

chkit delete pod pod_name [-n namespace]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | delete pod without confirmation | false |


**Subcommands**:



#### <a name="delete_namespace">delete namespace</a>

**Description**:

Delete namespace provided in the first arg.

**Example**:

chkit delete namespace $ID

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --force | suppress confirmation | false |
|  | --id | namespace id to delete |  |
|  | --label | namespace label or owner/label to delete |  |


**Subcommands**:



#### <a name="delete_ingress">delete ingress</a>

**Description**:

Delete ingress.

**Example**:

chkit delete ingress $INGRESS [-n $NAMESPACE] [--force]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | delete ingress without confirmation | false |


**Subcommands**:



#### <a name="delete_deployment-version">delete deployment-version</a>

**Description**:

Deployment name can be set as first arg, flag '--deployment' or in interactive menu.
Version can be set in free form (v1.0.2, 14.7, 3.6.0, etc.) or in interactive menu too.
Only inactive version can be selected.

In force mode both deployment and version parameters are required.

**Example**:

chkit delete deployment-version --deployment $DEPLOYMENT --version $VERSION --force

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --deployment | deployment name, can be chosen in interactive menu, required in force mode |  |
| -f | --force | suppress confirmation | false |
|  | --version | deployment version, can be chosen in interactive menu, required in force mode |  |


**Subcommands**:



#### <a name="delete_deployment-container">delete deployment-container</a>

**Description**:

Delete deployment container.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --container | container name, required on --force |  |
|  | --deployment | deployment name, required on --force |  |
|  | --force | suppress confirmation | false |


**Subcommands**:



#### <a name="delete_deployment">delete deployment</a>

**Description**:

Delete deployment. List of deployments to delete must be provided as argument. If list is empty, then chkit will start interactive menu.

**Delete list of deployments without --force**

```bash
> chkit delete deployment mimosa-warburg athamantis-gauss flora-onnes
Are you really want to delete to delete mimosa-warburg, athamantis-gauss, flora-onnes? [Y/N]: y
Deployment flora-onnes is deleted
Deployment mimosa-warburg is deleted
Deployment athamantis-gauss is deleted
3 deployments are deleted

```

**Delete list of deployments with --force**

```bash
> chkit delete depl --force lindenau-chayes malva-clarke pauwels-toepler
Deployment lindenau-chayes is deleted
Deployment malva-clarke is deleted
Deployment pauwels-toepler is deleted
3 deployments are deleted
```

**Delete deployment with interactive selection**

```bash
> chkit delete depl
Select deployment:
Selected:
 1) gurzhij-newton
 2) jackson-lenard
 3) kupe-magnus
 4) lindenau-chayes
 5) malva-clarke
 6) marchis-young
 7) pauwels-toepler
 8) rebentrost-thales
 9) Confirm
Choose wisely: 1
Select deployment:
Selected: gurzhij-newton
 1) jackson-lenard
 2) kupe-magnus
 3) lindenau-chayes
 4) malva-clarke
 5) marchis-young
 6) pauwels-toepler
 7) rebentrost-thales
 8) Confirm
Choose wisely: 2
Select deployment:
Selected: gurzhij-newton kupe-magnus
 1) jackson-lenard
 2) lindenau-chayes
 3) malva-clarke
 4) marchis-young
 5) pauwels-toepler
 6) rebentrost-thales
 7) Confirm
Choose wisely: 4
Select deployment:
Selected: gurzhij-newton kupe-magnus marchis-young
 1) jackson-lenard
 2) lindenau-chayes
 3) malva-clarke
 4) pauwels-toepler
 5) rebentrost-thales
 6) Confirm
Choose wisely: 1
Select deployment:
Selected: gurzhij-newton kupe-magnus marchis-young jackson-lenard
 1) lindenau-chayes
 2) malva-clarke
 3) pauwels-toepler
 4) rebentrost-thales
 5) Confirm
Choose wisely: 5
Are you really want to delete to delete gurzhij-newton, kupe-magnus, marchis-young, jackson-lenard? [Y/N]: y
Deployment gurzhij-newton is deleted
Deployment kupe-magnus is deleted
Deployment marchis-young is deleted
Deployment jackson-lenard is deleted
4 deployments are deleted

```

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -c | --concurrency | how much concurrent requeste can be performed at once | 4 |
|  | --force |  | false |


**Subcommands**:



#### <a name="delete_configmap">delete configmap</a>

**Description**:

delete configmap. Aliases: cm, confmap, conf-map, comap

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --force | delete pod without confirmation | false |


**Subcommands**:



