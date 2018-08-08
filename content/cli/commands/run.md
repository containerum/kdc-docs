---
description: run deployment version, solution.
draft: false
linktitle: run
menu:
  docs:
    parent: commands
    weight: 5
title: Run
weight: 2

---

#### <a name="run">run</a>

**Description**:

run deployment version, solution.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[run deployment-version](#run_deployment-version)** run specific deployment version. Aliases: depl-version, devers, deploy-vers, depver, deplver
* **[run solution](#run_solution)** run solution from template. Aliases: sol, solutions, sols, solu, so


#### <a name="run_solution">run solution</a>

**Description**:

Run solution.
Solution is an object that allows to create and manage several deployments and services at once.

There are several ways to run solution:
- --file flag, FILE_PATH
- interactive wizard

Use the --force flag to skip wizard

**Example**:

chkit run solution [$TEMPLATE] [--env=KEY1:VALUE1,KEY2:VALUE2] [--file $FILENAME] [--force]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --branch | solution git repo branch, optional |  |
|  | --env | solution environment variables, optional |  |
|  | --export-file | output file |  |
| -f | --force | suppress confirmation, optional | false |
|  | --import-file |  |  |
| -i | --input | input format, json/yaml |  |
|  | --name | solution name, optional |  |
| -o | --output | output format, json/yaml |  |
|  | --template | solution template, optional |  |


**Subcommands**:



#### <a name="run_deployment-version">run deployment-version</a>

**Description**:

Deployment name can be set as first arg, flag '--deployment' or in interactive menu.
Version can be set in free form (v1.0.2, 14.7, 3.6.0, etc.) or in interactive menu too.
If flag value is '-' or 'latest', then the latest version of deployment is used.

In force mode both deployment and version parameters are required.

**Example**:

chkit run deployment-version --deployment $DEPLOYMENT --version $VERSION --force

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --deployment | deployment name, can be chosen in interactive menu |  |
| -f | --force | suppress confirmation | false |
|  | --version | deployment version, can be chosen in interactive menu. If '-' or 'latest' then latest version is used. |  |


**Subcommands**:



