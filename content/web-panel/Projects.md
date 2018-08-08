---
title: Project - Containerum
linktitle: Project
description: How to create, update, view and delete an Project.
description:

categories: []
keywords: []

menu:
  docs:
    parent: "web-panel"
    weight: 1

draft: false
---

# How to work with a Project

## Description

Project is the main object of Containerum. To create a project a user needs to allocate RAM and CPU resources to the project. With Containerum a user can allocate as much of the available resources as necessary. All other system objects (deployments, services, etc.) can exist only within a Project. As part of teamwork, project owners can share their projects with other users and set access levels to build new software together.

A detailed description of the Project entity is available [here](/getting-started/object-types/#project).

## Requirements
To create a project you need to have enough available resources on your machine(s).

## Create

If you don't have any projects yet, click on the `Create project` button in the Dashboard.

<img src="/img/content/web-panel/project/createProjectDashboard.png" width="100%"/>

or go to the Projects tab in the main menu and click `Add a project` there.

<img src="/img/content/web-panel/project/createProject.png" width="100%"/>

 Enter the name and choose the right amount of resources for your project and click `Create project`.

 - Name - can include a-z, 0-9, -. Example: `test-project`.

 - CPU (in mCPU)- must be number. Example: `512`.

 - RAM - must be number. Example: `500`.


<img src="/img/content/web-panel/project/size.png" width="100%"/>

That's it, the project has been created.

## View

You can view the list of all your projects in the Dashboard.

<img src="/img/content/web-panel/project/projectsDashboard.png" width="100%"/>

Or you can view them in the Projects tab of the main menu.

<img src="/img/content/web-panel/project/projects.png" width="100%"/>

## Update

To change the resources allocated to a project, click `Resize` in the project context menu. The menu is available

- in the Dashboard:  

<img src="/img/content/web-panel/project/resizeDashboard.png" width="100%"/>

- in the Project tab:  

<img src="/img/content/web-panel/project/resizeProjects.png" width="100%"/>

- and on the Project page:  

<img src="/img/content/web-panel/project/resizeProject.png" width="100%"/>

Now you can change the amount of resources allocated to the project.  

## Delete

You can delete a project by clicking `Delete` in the project context menu. The menu is available

- in the Dashboard:  

<img src="/img/content/web-panel/project/resizeProjects.png" width="100%"/>

- and on the Project page:  

<img src="/img/content/web-panel/project/resizeProject.png" width="100%"/>

After a project is deleted, all its Deployments, Services, Domains, Configmaps and Solutions will also be deleted.
Note: This action cannot be undone.

## Teamwork

A project can be shared between several users. Admin user  can add users and set access rights to the project by clicking the Manage team button on the project page.

<img src="/img/content/web-panel/project/manageTeam.png" width="100%"/>
