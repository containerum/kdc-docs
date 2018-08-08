---
title: Travis
linktitle: Travis
description: Configuring CI/CD pipelines with Travis and Containerum

categories: []
keywords: []

menu:
  docs:
    parent: "ci-cd"
    weight: 1
    identifier: travis

draft: false
---

# Pipelines with Travis

This instruction describes how to setup a CI pipeline in Travis. It will allow the deployments launched in Containerum to update automatically once you push code to GitHub.

You have to follow these 3 steps for each deployment just once. After that your code will be built, tested and deployed by Travis once you push `git push` command.

Step 1. Create a project and push it to your repo on GitHub

Step 2. Register in [Travis](https://travis-ci.org) and add a repository from GitHub

Step 3. Add `.travis.yaml` to your project on GitHub with the following content:

```
sudo: required

services:
  - docker

install:
  - wget https://github.com/containerum/chkit/releases/download/${CHKIT_VERSION}/chkit_linux_amd64_${CHKIT_VERSION}.tar.gz
  - tar -zxf chkit_linux_amd64_${CHKIT_VERSION}.tar.gz && sudo mv chkit /bin/chkit

script:
  - chkit get api
  - chkit login -u ${LOGIN} -p ${PASSWORD} -n -
  - docker build -t "$IMAGE_NAME" .

before_deploy:
  - docker login -u="$DOCKER_LOGIN" -p="$DOCKER_PASSWORD"
  - docker tag "$IMAGE_NAME" "${IMAGE_NAME}:latest"
  - docker tag "$IMAGE_NAME" "${IMAGE_NAME}:release"
  - docker tag "$IMAGE_NAME" "${IMAGE_NAME}:${TRAVIS_COMMIT::8}"
  - if [ "$TRAVIS_TAG" ]; then docker tag "$IMAGE_NAME" "${IMAGE_NAME}:${TRAVIS_TAG}"; fi

deploy:
  - provider: script
    script:
      - echo "deploy 1"
      - docker push "${IMAGE_NAME}:latest"
      - docker push "${IMAGE_NAME}:${TRAVIS_TAG}"
    skip_cleanup: true
    on:
      tags: true
  - provider: script
    script:
      - echo "deploy 2"
      - chkit set image --deployment ${DEPLOY} --image "${IMAGE_NAME}:${TRAVIS_TAG}" --force
    skip_cleanup: true
    on:
      tags: true

  - provider: script
    script: docker push "${IMAGE_NAME}:latest" && docker push "${IMAGE_NAME}:${TRAVIS_COMMIT::8}"
    skip_cleanup: true
    on:
      branch: master
  - provider: script
    script: chkit set image --deployment ${DEPLOY} --image "${IMAGE_NAME}:${TRAVIS_COMMIT::8}" --force
    skip_cleanup: true
    on:
      branch: master
```

Add the required Environment Variables in Travis settings for your repository:

`CHKIT_VERSION` -  version of chkit (see it [here](https://github.com/containerum/chkit/releases]))

`LOGIN` - your email in Containerum

`PASSWORD` - your pwd in Containerum

`DOCKER_LOGIN` - docker login

`IMAGE_NAME` - image from hub.docker.com

`DEPLOY` - name of your deploy in Containerum

`IMAGE_NAME` and `TRAVIS_COMMIT` - default Travis variables, you don't have to specify them.

Don't forget to hide sensitive information like credentials. Otherwise it will be available to everyone viewing your logs.

For extra settings see [Travis docs](https://docs.travis-ci.com).
