# Documentation for Kubernetes Distribution by Containerum

[![Build Status](https://travis-ci.org/containerum/cdk-docs.svg?branch=master)](https://travis-ci.org/containerum/cdk-docs)

[Stable documentation](https://docs.cdk.containerum.com)  
[Staging documentation](https://cdk-docs.hub.containerum.io)

Cdk-docs is a documentation project for [Kubernetes Distribution by Containerum (KDC)](https://containerum.com/kubernetes/). It contains guides on installing KDC, manuals and release notes.
DKC Docs can be launched locally with YARN and Hugo. We strive to make docs as clear and substantial as possible, so we welcome contributions and advice.


## Requirements
* [Hugo](https://github.com/gohugoio/hugo) > v0.39
* [YARN](https://yarnpkg.com)


## Run locally
If you want to contribute to docs and watch changes locally before you make a commit, run:
```
  gulp build
  hugo serve --bind 0.0.0.0 -w
```
Now you can access the docs at 127.0.0.1:1313

## Build
If you just want to build the docs project, run:
```
  gulp build
  hugo
```

## Note
1. All *static* files should be put in **static_src** folder
2. All images for content should be put in corresponding folder in **static_src/img/content**.
E.g. To use *img.png* in */content/release-notes/cli.md*, the path for the picture should be */static_src/img/content/release-notes/cli/img.png*.

## License
Copyright (c) 2015-2018 Exon LV.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
