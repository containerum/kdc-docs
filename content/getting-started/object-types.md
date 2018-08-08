---
title: Object types
linktitle: Object types
description: The core concepts of Containerum (project, deployment, ingress, etc.).

categories: []
keywords: []

menu:
  docs:
    parent: "getting-started"
    weight: 2

draft: false
---
# Object types
In Containerum a user can generally operate the following objects:

<head>
  <style type="text/css">
  table {
  	border: 1px solid #0B0746;
  	border-collapse: collapse
  }
   th {
    background-color: #ebebeb;
    border: 1px solid #0B0746;
   }
   td {
   	border: 1px solid #0B0746;

   }
   ul {
    margin-top: 0;
    margin-bottom: 0;
   }
  </style>
</head>
<body>
<ul>
	<li><a href="#project"  style="color: black"><i>Project</i></a></li>
	<li><a href="#deployment"  style="color: black"><i>Deployment</i></a></li>
	<li><a href="#pod"  style="color: black"><i>Pod</i></a></li>
	<li><a href="#service"  style="color: black"><i>Service</i></a></li>
	<li><a href="#ingress"  style="color: black"><i>Ingress</i></a></li>
	<li><a href="#configmap"  style="color: black"><i>Configmap</i></a></li>
</ul>

<br/>
<h4><a id="project" name="project">Project</a></h4>

Project is the main object of Containerum system. To create a project a user needs to allocate RAM and CPU resources to the project. With <a href="https://github.com/containerum/containerum">Containerum self-hosted</a> a user can allocate as much of the available server resources as necessary. <a href="https://web.containerum.io">Containerum Online</a> offers several preconfigured options (custom configurations available upon [request](https://containerum.com/sales/)). All other system objects (deployments, services, etc.) exist only within a Project. As part of teamwork, project owners can share their projects with other users and set access levels to create new software together.

Project consists of the following fields:

<table>
	<tbody>
		<tr>
		  	<th width="20%">Field</th>
		  	<th width="7%">Type</th>
		  	<th width="53%">Description</th>
		  	<th width="20%">Example</th>
		</tr>
		<tr>
		  	<td>id</td>
		  	<td><i>uui4</i></td>
		  	<td>Object identifier, which is the real project name in Containerum system. Should be unique for every project.</td>
		  	<td>8d616b02-1ea7-4842-b8ec-c6e8226fda5b</td>
		</tr>
		<tr>
		  	<td>label</td>
		  	<td><i>string</i></td>
		  	<td>Object name, set by a user. It doesn't have to be unique, as Containerum API uses the id field for routing.</td>
		  	<td>myNamespace</td>
		</tr>
		<tr>
			<td>owner</td>
			<td><i>uui4</i></td>
			<td>Identifier of the project owner, which is a user identifier inside Containerum system. There can only be one project owner.</td>
			<td>20b616d8-1ea7-4842-b8ec-c6e8226fda5b</td>
		</tr>
		<tr>
			<td>access</td>
			<td><i>string</i></td>
			<td>User access level in the project. Available values: owner, write, read.</td>
			<td>owner</td>
		</tr>
		<tr>
			<td>resources:</td>
			<td><i>object</i></td>
			<td colspan="2">Resources allocated to the project.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>hard:</li>
				</ul>
			</td>
			<td><i>object</i></td>
			<td colspan="2">Allocated resources.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>cpu</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Allocated CPU. To simplify CPU allocation Containerum uses only mCPU units. mCPU = 10**-3 CPU.</td>
			<td>100</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>memory</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Allocated RAM. To simplify RAM allocation Containerum uses only <a href="https://en.wikipedia.org/wiki/Mebibit">Mi</a> units.</td>
			<td>128</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>used:</li>
				</ul>
			</td>
			<td><i>object</i></td>
			<td colspan="2">Actually used resources.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>cpu</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Used CPU value in mCPU.</td>
			<td>50</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>memory</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Used RAM value in Mi.</td>
			<td>100</td>
		</tr>		
	</tbody>
</table>

<br/>
<h4><a name="deployment">Deployment</a></h4>

Deployment is an object that contains the configuration of running applications. It has a large number of parameters, that can be set during deployment creation. One of the main parameters is a container. Containers describe images, resources, environment variables, etc. that are necessary for user applications to run properly. One or more applications can run in one deployment. Users can describe apps in separate deployments and connect them using <a href="#service">internal services</a> or describe apps as different containers belonging to the same deployment. In this case, applications are accessible to each other by the container name and port. A user can bind <a href="#configmap">configmaps</a> to deployments to use configuration files, certificates, etc. Containerum deployments support revision control. When a user updates a deployment image, the new revision will be saved in Containerum. User can get a revision list, rename a revision, rollback to any selected version, etc. Containerum uses semantic versioning for deployments.

Deployment consists of the following fields:

<table width="100%">
	<tbody>
		<tr>
		  	<th width="20%">Field</th>
		  	<th width="7%">Type</th>
		  	<th width="53%">Description</th>
		  	<th width="20%">Example</th>
		</tr>
		<tr>
		  	<td>name</td>
		  	<td><i>string</i></td>
		  	<td>Object name. Should be unique within a Project.</td>
		  	<td>myDeployment</td>
		</tr>
		<tr>
		  	<td>replicas</td>
		  	<td><i>uint</i></td>
		  	<td>Number of application replicas. Available values: 0..15. If a user sets replicas to 0, every pod for the chosen deployment will be terminated.</td>
		 	 <td>1</td>
		</tr>
		<tr>
			<td>containers:</td>
			<td><i>array</i></td>
			<td colspan="2">Container list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>name</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Container name. Should be unique within a Deployment.</td>
			<td>myContainer</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>image</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>App Docker image.</td>
			<td>nginx</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>limits:</li>
				</ul>
			</td>
			<td><i>object</i></td>
			<td colspan="2">Resources allocated for a container.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>cpu</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Allocated CPU. To simplify CPU allocation Containerum uses only mCPU units. mCPU = 10**-3 CPU.</td>
			<td>100</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>memory</li>
					</ul>
				</ul>
			</td>
			<td><i>uint</i></td>
			<td>Allocated RAM. To simplify RAM allocation Containerum uses only <a href="https://en.wikipedia.org/wiki/Mebibit">Mi</a> units.</td>
			<td>128</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>env:</li>
				</ul>
			</td>
			<td><i>array objects</i></td>
			<td colspan="2">Environments list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>name</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Environment name.</td>
			<td>CONTAINERUM_API</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>value</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Environment value.</td>
			<td>https://api.containerum.io</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>config_maps:</li>
				</ul>
			</td>
			<td><i>array objects</i></td>
			<td colspan="2">Configmap list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>name</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Configmap name. Should be unique within a Project.</td>
			<td>myConfigmap</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>mount_path</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Path for a configmap to mount to. It is a path inside the container file system.</td>
			<td>/home/user</td>
		</tr>
	</tbody>
</table>

<br/>
<h4><a name="pod">Pod</a></h4>

Pod is an object that constitutes one running <a href="#deployment"> deployment </a>replica. Although a deployment contains configuration data, pod is actually a running application. A pod cannot exist without a deployment, while a deployment can have no pods. When a user creates a deployment with 4 replicas, 4 pods will be created. In this case, each of them utilizes the amount of resources utilized by all containers in the parent deployment. When a user deletes a pod, a new one with the same configuration will be created. Containerum allows viewing logs for pods.

<br/>
<h4><a id="service" name="service">Service</a></h4>

Service is an object, used by <a href="#deployment"> applications </a> for communication with each other within Containerum ecosystem or with external applications. A service can be internal or external. An internal service connects deployments by the internal network of Kubernetes. External services allow users to access the deployment from the Internet. Each service can have several ports using TCP or UDP protocol.

Service consists of the following fields:

<table>
	<tbody>
		<tr>
		  	<th width="20%">Field</th>
		  	<th width="7%">Type</th>
		  	<th width="53%">Description</th>
		  	<th width="20%">Example</th>
		</tr>
		<tr>
		  	<td>name</td>
		  	<td><i>string</i></td>
		  	<td>Object name. Should be unique within a Project.</td>
		  	<td>myService</td>
		</tr>
		<tr>
		  	<td>deploy</td>
		  	<td><i>string</i></td>
		  	<td>Target deployment. It is necessary to choose the target application.</td>
		  	<td>myDeployment</td>
		</tr>
		<tr>
			<td>ports:</td>
			<td><i>array objects</i></td>
			<td colspan="2">Ports list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>portname</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Port name. Should be unique within a service.</td>
			<td>myPort</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>port</li>
				</ul>
			</td>
			<td><i>uint(11000-65535)</i></td>
			<td>External port. For an external service it is a port, that allows users to access the deployment from the Internet. For an internal service it is a port, that allows a chosen deployment to communicate with another deployment within the cluster.</td>
			<td>8080</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>target_port</li>
				</ul>
			</td>
			<td><i>uint(1-65535)</i></td>
			<td>Internal port. The port of deployment, where a running app is launched. In Dockerfile this is a port from EXPOSE instruction.</td>
			<td>80</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>protocol</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Port protocol. TCP or UDP are supported.</td>
			<td>TCP</td>
		</tr>
	</tbody>
</table>

<br/>
<h4><a name="ingress">Ingress</a></h4>

Ingress is an object that controls access to <a href="#service"> services </a> through DNS. Ingresses can work through http or secure https protocols and support TLS-protocol. Users can use standard Containerum TLS certs or their own certificates. Ingresses can contain rules for routing across several domains and different paths. For example, an Ingress connects <i>hello.hub.containerum.io/</i> to the service <i>svc0</i> of the main application, while <i>hello.hub.containerum.io/blog</i> is connected to the service <i>svc1</i> of the blog application.

Ingress consists of the following fields:

<table width="100%">
	<tbody>
		<tr>
		  	<th width="20%">Field</th>
		  	<th width="7%">Type</th>
		  	<th width="53%">Description</th>
		  	<th width="20%">Example</th>
		</tr>
		<tr>
		  	<td>name</td>
		  	<td><i>string</i></td>
		  	<td>Object name. Should be unique within a Project.</td>
		  	<td>myIngress</td>
		</tr>
		<tr>
		  	<td>rules:</td>
		  	<td><i>array objects</i></td>
		  	<td colspan="2">Routing rules list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>host</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>URL Domain. Containerum Online currently supports subdomains only for hub.containerum.io, but on request our team will help to set up any other domain name. Containerum self-hosted has no domain restrictions.</td>
			<td>hello.hub.containerum.io</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>tls_secret</li>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>TLS support. If supported, secret name should be specified.</td>
			<td>tls-cert</td>
		</tr>
		<tr>
			<td>
				<ul>
					<li>path:</li>
				</ul>
			</td>
			<td><i>array objects</i></td>
			<td colspan="2">Paths list.</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>path</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>URL path.</td>
			<td>/project</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>service_name</li>
					</ul>
				</ul>
			</td>
			<td><i>string</i></td>
			<td>Target service. It is necessary to choose a target service.</td>
			<td>myService</td>
		</tr>
		<tr>
			<td>
				<ul>
					<ul>
						<li>service_port</li>
					</ul>
				</ul>
			</td>
			<td><i>uint(11000-65535)</i></td>
			<td>Target port of the selected service.</td>
			<td>8080</td>
		</tr>
	</tbody>
</table>

<br/>
<h4><a name="configmap">Configmap</a></h4>

Configmap is an object that is basically a key-value storage. It can contain any text data, for example, configuration artifacts, certificates, keys or environment variables. Configmap data is stored without any encryption, so you should only add the data that does not have additional security requirements.

Configmap consists of the following fields:

<table>
	<tbody>
		<tr>
		  	<th width="20%">Field</th>
		  	<th width="7%">Type</th>
		  	<th width="53%">Description</th>
		  	<th width="20%">Example</th>
		</tr>
		<tr>
		  	<td>name</td>
		  	<td><i>string</i></td>
		  	<td>Object name. Should be unique within a Project.</td>
		  	<td>myConfigmap</td>
		</tr>
		<tr>
		  	<td>data</td>
		  	<td><i>object</i></td>
		  	<td>Data that contains information in the key-value format, like key0:value0, key1:value1. In general, the key is the name of the downloaded file, and the value is the file data.</td>
		  	<td>1.txt:Hello World</td>
		</tr>
	</tbody>
</table>

</body>
