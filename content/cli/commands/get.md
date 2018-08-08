---
description: get access, configmap, containerum api, default namespace, deployment,
  deployment versions, diff, ingress, namespace, pod, profile, service, solution,
  template, template_envs, volume.
draft: false
linktitle: get
menu:
  docs:
    parent: commands
    weight: 5
title: Get
weight: 2

---

#### <a name="get">get</a>

**Description**:

get access, configmap, containerum api, default namespace, deployment, deployment versions, diff, ingress, namespace, pod, profile, service, solution, template, template_envs, volume.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:

* **[get access](#get_access)** print namespace access data. Aliases: namespace-access, ns-access
* **[get configmap](#get_configmap)** show configmap data. Aliases: cm, confmap, conf-map, comap
* **[get containerum-api](#get_containerum-api)** print Containerum API URL. Aliases: api, current-api, api-addr, API
* **[get default-namespace](#get_default-namespace)** print default namespace. Aliases: default-ns, def-ns
* **[get deployment](#get_deployment)** show deployment data. Aliases: depl, deployments, deploy, de, dpl, depls, dep
* **[get deployment-versions](#get_deployment-versions)** get deployment versions. Aliases: depl-ver, depvers, deployment-version
* **[get diff](#get_diff)** show diff between deployment versions
* **[get ingress](#get_ingress)** show ingress data. Aliases: ingr, ingresses, ing
* **[get namespace](#get_namespace)** show namespace data or namespace list. Aliases: ns, namespaces
* **[get pod](#get_pod)** show pod info. Aliases: po, pods
* **[get profile](#get_profile)** show profile info. Aliases: me, user
* **[get service](#get_service)** show service info. Aliases: srv, services, svc, serv
* **[get solution](#get_solution)** Show running solutions info. Aliases: sol, solutions, sols, solu, so
* **[get template](#get_template)** get solutions templates. Aliases: tmpl, templates, tmpls, tmp, tmps
* **[get template_envs](#get_template_envs)** get solutions template envs. Aliases: template_env, tmpl_env, envs, environments, templates_environments, tmpls_env, tmpenv, tmp_env, tmps_env, tmpsenv
* **[get volume](#get_volume)** get volume info. Aliases: volumes, vol


#### <a name="get_volume">get volume</a>

**Description**:

get volume info. Aliases: volumes, vol

**Example**:

chkit get volume [$VOLUME_NAME...] [-o yaml] [--file $VOLUME_DATA_FILE]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
|  | --names | print only names | false |
| -o | --output | output format, json/yaml |  |


**Subcommands**:



#### <a name="get_template_envs">get template_envs</a>

**Description**:

Show list of solution environments.You can select specific branch specifying branch query (--branch). Default branch is 'master':


**Example**:

chkit get template_envs [name]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --branch | solution template branch |  |
| -f | --file | output file |  |
| -o | --output | output format (yaml/json) |  |


**Subcommands**:



#### <a name="get_template">get template</a>

**Description**:

Show list of available solutions templates. To search solution by name add arg.

**Example**:

chkit get template [name]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --file | output file |  |
| -o | --output | output format (yaml/json) |  |


**Subcommands**:



#### <a name="get_solution">get solution</a>

**Description**:

Show running solutions info. Aliases: sol, solutions, sols, solu, so

**Example**:

chkit get solution solution_name [-o yaml/json] [-f output_file]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --file | output file | - |
| -o | --output | output format [yaml/json] |  |


**Subcommands**:



#### <a name="get_service">get service</a>

**Description**:

Show service info.

**Example**:

chkit get service service_label [-o yaml/json] [-f output_file]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --file | output file | - |
| -o | --output | output format [yaml/json] |  |
| -s | --solution | solution name |  |


**Subcommands**:



#### <a name="get_profile">get profile</a>

**Description**:

Shows profile info.

**Example**:

chkit get profile

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:



#### <a name="get_pod">get pod</a>

**Description**:

Show pod info.

**Example**:

chkit get pod pod_label [-o yaml/json] [-f output_file]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --failed | include in result pods with status 'Failed' | false |
|  | --filename | output filename, STDOUT if empty of '-' |  |
| -o | --output | output format, yaml/json |  |
|  | --pending | include in result pods with status 'Pending' | false |
|  | --running | include in result pods with status 'Running' | false |
|  | --status | include in result pods with custom status |  |


**Subcommands**:



#### <a name="get_namespace">get namespace</a>

**Description**:

show namespace data or namespace list.

**Example**:

chkit get $ID... [-o yaml/json] [-f output_file]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
|  | --find | find namespace which name contains substring |  |
|  | --names | print namespace names | false |
| -o | --output | output format, json/yaml |  |


**Subcommands**:



#### <a name="get_ingress">get ingress</a>

**Description**:

Print ingress data.

**Example**:

chkit get ingress ingress_names... [-n namespace_label] [-o yaml/json]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
| -f | --file | output file |  |
| -o | --output | output format (yaml/json) |  |


**Subcommands**:



#### <a name="get_diff">get diff</a>

**Description**:

show diff between deployment versions

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --another-version | second deployment version to compare |  |
|  | --deployment | deployment name, optional |  |
|  | --output | diff output, STDOUT by default |  |
|  | --version | first deployment version to compare |  |


**Subcommands**:



#### <a name="get_deployment-versions">get deployment-versions</a>

**Description**:

Get deployment versions.
You can filter versions by specifying version query (--version):
Valid queries are:

  - "<1.0.0"
  - "<=1.0.0"
  - ">1.0.0"
  - ">=1.0.0"
  - "1.0.0", "=1.0.0", "==1.0.0"
  - "!1.0.0", "!=1.0.0"
A query can consist of multiple querys separated by space:
queries can be linked by logical AND:
  - ">1.0.0 <2.0.0" would match between both querys, so "1.1.1" and "1.8.7" but not "1.0.0" or "2.0.0"
  - ">1.0.0 <3.0.0 !2.0.3-beta.2" would match every version between 1.0.0 and 3.0.0 except 2.0.3-beta.2
Queries can also be linked by logical OR:
  - "<2.0.0 || >=3.0.0" would match "1.x.x" and "3.x.x" but not "2.x.x"
AND has a higher precedence than OR. It's not possible to use brackets.
Queries can be combined by both AND and OR
 - `>1.0.0 <2.0.0 || >3.0.0 !4.2.1` would match `1.2.3`, `1.9.9`, `3.1.1`, but not `4.2.1`, `2.1.1`

**Example**:

chkit get deployment-versions MY_DEPLOYMENT [--last-n 4] [--version >=1.0.0] [--output yaml] [--file versions.yaml]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
|  | --last-n | limit n versions to show | 0 |
| -o | --output | output format, json/yaml |  |
|  | --version | version query, examples: <1.0.0, <=1.0.0, !1.0.0 |  |


**Subcommands**:



#### <a name="get_deployment">get deployment</a>

**Description**:

Print deployment data.

**Example**:

namespace deployment_names... [-n namespace_label]

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --export-file | output file |  |
| -o | --output | output format, json/yaml |  |
|  | --solution |  |  |


**Subcommands**:



#### <a name="get_default-namespace">get default-namespace</a>

**Description**:

Print default namespace.

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:



#### <a name="get_containerum-api">get containerum-api</a>

**Description**:

print Containerum API URL. Aliases: api, current-api, api-addr, API

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:



#### <a name="get_configmap">get configmap</a>

**Description**:

show configmap data. Aliases: cm, confmap, conf-map, comap

**Example**:



**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |
|  | --file | output file | - |
| -o | --output | output format yaml/json |  |


**Subcommands**:



#### <a name="get_access">get access</a>

**Description**:

Print namespace access data.

**Example**:

chkit get ns-access $ID

**Flags**:

| Short | Name | Usage | Default value |
| ----- | ---- | ----- | ------------- |


**Subcommands**:



