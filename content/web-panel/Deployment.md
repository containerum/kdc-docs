---
title: Deployment - Containerum
linktitle: Deployment
description: How to create, update, view and delete an Deployment.

categories: []
keywords: []

menu:
  docs:
    parent: "web-panel"
    weight: 2

draft: false
---

# How to work with a Deployment

## Description

Deployment is an object that contains the configuration of running applications. It has a large number of parameters, that can be set during deployment creation. One of the main parameters is a container. Containers describe images, resources, environment variables, etc. that are necessary for user applications to run properly. One or more applications can run in one deployment.
Users can describe apps in separate deployments and connect them using [internal services](/getting-started/object-types/#service)
or describe apps as different containers belonging to the same deployment.
In this case, applications are accessible to each other by the container name and port.
A user can bind [configmaps](/getting-started/object-types/#configmap) to deployments to use configuration files, certificates, etc.
Containerum deployments support revision control. When a user updates a deployment image, the new revision
will be saved in Containerum. User can get a revision list, rename a revision, rollback to any selected version, etc. Containerum uses semantic versioning for deployments.

## Requirements
A project is required to create a deployment.

## Create

To create an Deployment, choose an existing Project, go to Deployments section and click on the `Create` button.

 <img src="/img/content/web-panel/Deployment/getDeployments.png" width="100%"/>

Fill in the fields:

- Deployment Name - can include a-z, 0-9, -. Example: `helloworld`.

- Replicas count - must be number. Example: `1`

<img src="/img/content/web-panel/Deployment/createDeployment1.png" width="100%"/>

- Container name - can include a-z, 0-9, -. Example: `helloworld`.
- Docker Image - can include a-z, 0-9, -. Example: `containerum/helloworld`.
- Parameters:
    - CPU (in mCPU) - must be number. Range: 10 - 3000. Example: `100`.
    - RAM - must be number. Range: 10 - 8000. Example: `100`.
- Environments:
    - Name - can include a-z, 0-9, -.
    - Value - can include a-z, 0-9, -.
<img src="/img/content/web-panel/Deployment/createDeployment2.png" width="100%"/>

Then click on the `Create Deployment` button. Done!

### View

You can view all deployments on the Deployments tab (`/projects/:idNamespace/deployments`).

<img src="/img/content/web-panel/Deployment/getDeploymentsList.png" width="100%"/>

You can also click on a deployment and get detailed information. (`/project/:idNamespace/deployments/:deploymentName`)

<img src="/img/content/web-panel/Deployment/getDeployment.png" width="100%"/>

### Update

You can update any deployment by clicking `Update` in the context menu:     

- on the Deployments tab

<img src="/img/content/web-panel/Deployment/callContextDeploymentMenuUpdate1.png" width="100%"/>

- or on a page with detailed information about the deployment.

<img src="/img/content/web-panel/Deployment/callContextDeploymentMenuUpdate2.png" width="100%"/>

You can change replicas count, container name, docker image, parameters, environments, add or delete new containers.

<img src="/img/content/web-panel/Deployment/updateDeployment1.png" width="100%"/>
<img src="/img/content/web-panel/Deployment/updateDeployment2.png" width="100%"/>

After changing the required information, click on `UPDATE DEPLOYMENT`.

### Delete

You can Delete a deployment by clicking `Delete` in the context menu:

- on the Deployments tab

<img src="/img/content/web-panel/Deployment/callContextDeploymentMenuDelete1.png" width="100%"/>

- or on a page with detailed information about the deployment.

<img src="/img/content/web-panel/Deployment/callContextDeploymentMenuDelete2.png" width="100%"/>

Then you will be asked to confirm deployment deletion. Enter the deployment name and click `Delete`.
<img src="/img/content/web-panel/Deployment/deleteDeploymentModal.png" width="100%"/>

Note: by clicking `Delete` you will delete the deployment immediately. This action cannot be undone.
