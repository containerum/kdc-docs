---
title: Online Platform
linktitle: Containerum Online
description: First steps to start using Containerum Online.

categories: []
keywords: []

menu:
  docs:
    parent: "getting-started"
    weight: 3

draft: false
---


# Getting started with Containerum Online
Here are the fist steps to launch your first application on Containerum Online.

##### 1. Registration
To start using Containerum, register with your email, and prove that you are not a robot.

You will receive a letter with registration confirmation link shortly.

Click the link  - the registration is complete! Now you will see the Dashboard page.

<img src="/img/content/getting-started/online/newRegistration.png" width="100%"/>

##### 2. Billing
The next step is to top up your account. In the right drop-down menu choose *Billing*.

<img src="/img/content/getting-started/online/moveToBilling.png" width="100%"/>

On the Billing page click *Add funds* to top up your account with your card or PayPal.

<img src="/img/content/getting-started/online/billing.png" width="100%"/>


##### 3. Create a Project

Now create your first Project.

Go to the Projects tab and click *Add a project*.

<img src="/img/content/getting-started/online/moveToCreateProject.png" width="100%"/>

Now choose the size of your Project.

<img src="/img/content/getting-started/online/chooseSize.png" width="100%"/>


Now that you have created a Project you can go the Project page.

You can access all your Projects at the Projects tab in the main menu.

##### 4. Create a Deployment

Let's create your first Deployment. Click *Create* on the *Deployment* page.

<img src="/img/content/getting-started/online/createDepl1.png" width="100%"/>

Enter the Deployment name and the number of replicas - 1.

<img src="/img/content/getting-started/online/createDepl2.png" width="100%"/>

Enter the following data:
- container name - hello.
- docker image you want to use - containerum/helloworld.
- CPU (in mCPU) and RAM (in Mi) - 500.

Then click *Create deployment*.

##### 5. Create a Service

Now let's create an external service for your project to make it accessible from the outside.

On the *Services* tab click *Create*.

<img src="/img/content/getting-started/online/moveToCreateService.png" width="100%"/>


Now create an external service.

Choose the target deployment, enter the service name, port name and port address (80).

<img src="/img/content/getting-started/online/createService.png" width="100%"/>

Done!

##### 6. Create a Domain

Now let's create a domain for this external service. Click *Create domain*.

<img src="/img/content/getting-started/online/moveToCreateDomain.png" width="100%"/>

Enter the domain name and check *Enable SSL Security* box.

<img src="/img/content/getting-started/online/createDomain.png" width="100%"/>

##### 7. Go to the domain page

Go to the *Tools* tab in the main menu and choose *Domains*. You will see the list of your domains.

<img src="/img/content/getting-started/online/domains.png" width="100%"/>

Click on the domain or enter the address manually in a new tab to see your application.

<img src="/img/content/getting-started/online/result.png" width="100%"/>


Congratulations! You've just created a Project and launched an application on Containerum Online Platform. Now it's time to learn more about [Containerum Web Panel](/web-panel/) and [CLI](/cli/).
