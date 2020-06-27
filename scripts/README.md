# Kind tests

## Cluster setup

```
$ kind create cluster --config=kind.yaml
$ kubectl cluster-info
Kubernetes master is running at https://127.0.0.1:32768
```

## Ingress

```
$ helm install nginx-ingress stable/nginx-ingress -n kube-system \
  --set controller.kind=DaemonSet \
  --set controller.daemonset.useHostPort=true
```
