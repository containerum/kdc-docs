---
title: Domains - Containerum
linktitle: Domains
description: How to create, update, view and delete an Domains.

categories: []
keywords: []

menu:
  docs:
    parent: "web-panel"
    weight: 5

draft: false
---

# How to work with a Domain

## Description

Domain is the address where you or other Internet users can access your application.

## Create

Domains can be created for an external service only.

After creating an external service, you'll be offered to create a domain for it.

<img src="/img/content/web-panel/domains/createDomainAfterCreateService.png" width="100%"/>

You can also create a domain by clicking `Create` in the `Domains` tab on the Project page.

<img src="/img/content/web-panel/domains/projectDomains.png" width="100%"/>


Fill in the fields:  
- Service - External service which will be assigned the domain name  (e.g. my-service)  
- Domain - domain name  (e.g. my-site.io)  
- /Path - path for the external service on the domain (e.g. `/blog` will bind the service to `my-site.io/blog`)  
- Enable SSL Security - tick the box if you want to issue a certificate for the domain.  

 Once done, click `Create Domain`.


<img src="/img/content/web-panel/domains/createDomain.png" width="100%"/>


## View

You can view your domains in the `Domains` tab on the `Project` page:

<img src="/img/content/web-panel/domains/viewDomains.png" width="100%"/>

You can also view the domains across **all** projects on the `Domains` page (`/tools => /domains`):

<img src="/img/content/web-panel/domains/globalViewDomains.png" width="100%"/>

## Update

Once created, a domain cannot be updated.

## Delete

To delete a domain go to the Domains tab on the `Project` page and click `Delete` in the context menu of the Domain you want to delete.

<img src="/img/content/web-panel/domains/deleteDomain.png" width="100%"/>

You can also delete domains on the `Domains` page (`/tools => /domains`).

<img src="/img/content/web-panel/domains/globalDeleteDomain.png" width="100%"/>

## Connections and dependencies

A domain is bound to the external service it is assigned to.
