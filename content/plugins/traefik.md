---
title: Traefik
linktitle: Traefik
description: Installing Traefik to access applications in Kubernetes by an External IP.

categories: []
keywords: []

menu:
  docs:
    parent: "plugins"
    weight: 7
    identifier: traefik

draft: true
---

# How to install Traefik for Kubernetes

Traefik is required to access applications running in Kubernetes by an External IP.

## When to use Traefik
Упрощает управление ingress в Kubernetes. Предоставляет возможность использовать из коробки сертификаты Let's Encrypt. Имеет Rest API. Предоставляет метрики для Prometheus (и много чего еще перечисленного на сайте).

## Installation

Создайте ClusterRole для ServiceAccount traefik-ingress-controller:
```
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
```


При разворачивании traefik в качестве Deploy создайте файл traefik-deployment.yaml со следующим содержимым:
```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
---
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
  labels:
    k8s-app: traefik-ingress-lb
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: traefik-ingress-lb
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      containers:
      - image: traefik
        name: traefik-ingress-lb
        ports:
        - name: http
          containerPort: 80
        - name: admin
          containerPort: 8080
        args:
        - --api
        - --kubernetes
        - --logLevel=INFO
---
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
spec:
  ports:
  - name: http
    port: 80
    targetPort: 80
    protocol: TCP
  - name: https
    port: 443
    targetPort: 443
    protocol: TCP
  selector:
    app.kubernetes.io/name: ingress-nginx
  externalIPs:
  - {$EXTERNAL_IP}
```
Укажите в {$EXTERNAL_IP} IP адреса на которые будет идти трафик.

Запустите Traefik в Kubernetes:
```bash
kubectl apply -f traefik-deployment.yaml
```


При разворачивании traefik в качестве DS создайте файл traefik-ds.yaml со следующим содержимым:
```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
---
kind: DaemonSet
apiVersion: extensions/v1beta1
metadata:
  name: traefik-ingress-controller
  namespace: kube-system
  labels:
    k8s-app: traefik-ingress-lb
spec:
  template:
    metadata:
      labels:
        k8s-app: traefik-ingress-lb
        name: traefik-ingress-lb
    spec:
      serviceAccountName: traefik-ingress-controller
      terminationGracePeriodSeconds: 60
      containers:
      - image: traefik
        name: traefik-ingress-lb
        ports:
        - name: http
          containerPort: 80
          hostPort: 80
        - name: admin
          containerPort: 8080
        securityContext:
          capabilities:
            drop:
            - ALL
            add:
            - NET_BIND_SERVICE
        args:
        - --api
        - --kubernetes
        - --logLevel=INFO
---
kind: Service
apiVersion: v1
metadata:
  name: traefik-ingress-service
  namespace: kube-system
spec:
  selector:
    k8s-app: traefik-ingress-lb
  ports:
    - protocol: TCP
      port: 80
      name: web
    - protocol: TCP
      port: 8080
      name: admin
```

Запустите Traefik в Kubernetes:
```bash
kubectl apply -f traefik-ds.yaml
```

Также вы можете запустить ui для Traefik:
```bash
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/ui.yaml
```

Пропишите на своем хосте `/etc/hosts` путь до `traefik-ui.minikube` и перейдите в своем браузере в ui