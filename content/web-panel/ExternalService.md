---
title: External Service
linktitle: External Service
description: How to create, update, view and delete an External service.

categories: []
keywords: []

menu:
  docs:
    parent: "web-panel"
    weight: 4

draft: false
---

# How to work with an External Service

## Description

Service is an object, used by applications for communication with each other within Containerum ecosystem or with external applications. A service can be internal or external. External services allow users to access the deployment from the Internet.

Each service can have several ports using TCP or UDP protocol.

## Requirements
A project and a deployment are required to create a service.

## Create

To create an External service for a Deployment, choose an existing Project, go to Services section and click on the `Create` button.

 <img src="/img/content/web-panel/serviceInNS.png" width="100%"/>


Please note, that each service has to be linked to a particular deployment. If there are no deployments in your project yet, you have to [create a deployment](/web-panel/deployment) first.

Select a Deployment, then click on the `EXTERNAL SERVICE` switch and fill in the fields:

- Service Name - can include a-z, 0-9, -. Example: `helloworld-external-service`

- Port Name - can include a-z, 0-9, -. Example: `helloworld-port`

- Target port - must be the same as deployment port. Example: `5000`

- Protocol type: `TCP`

<img src="/img/content/web-panel/createExternalService.png" width="100%"/>

Then click on the `Create Service`. Done.

## View

You can view all services in the Services tab (`/projects/:idNamespace/services`).

<img src="/img/content/web-panel/getServicesList.png" width="100%"/>

You can also click on a service and see detailed information like IPs, domains, ports, and linked deployments. (`/project/:idNamespace/services/:serviceName`)

<img src="/img/content/web-panel/getService.png" width="100%"/>

## Update

You can update any service by clicking `Update` in the context menu on the Services tab or on the page with detailed information about the service.

<img src="/img/content/web-panel/callContextServiceMenuUpdate.png" width="100%"/>

You can change port parameters, delete or add new ports.

<img src="/img/content/web-panel/updateExternalService.png" width="100%"/>

After changing the required information, click on `UPDATE SERVICE`.

## Delete

You can Delete a service by clicking `Delete` in the context menu on the Services tab or on the page with detailed information about the service.

<img src="/img/content/web-panel/callContextServiceMenuDelete.png" width="100%"/>

Note: by clicking `Delete` you will delete the service immediately. This action cannot be undone.
If you delete an External service, you won't be able to reach your deployment from the Internet until you create a new External Service.
