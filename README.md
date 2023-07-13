Sample Kubernetes Gateway API
---

This is a sample of the Gateway API.


## Description

This is a sample that uses the Gateway API to access the application instead of Ingress.


## Structure

### Used tools and other components

| tools                                           | description                                               |
|-------------------------------------------------|-----------------------------------------------------------|
| [Kubernetes](https://kubernetes.io/)            | container orchestrator                                    |
| [Minikube](https://minikube.sigs.k8s.io/docs/)  | tool for quickly sets up a local Kubernetes cluster       |
| [Skaffold](https://skaffold.dev/)               | tool for building, pushing and deploying your application |
| [Kustomize](https://kustomize.io/)              | tool for simple management of manifest files              |
| [Gateway API](https://gateway-api.sigs.k8s.io/) | tool for service networking                               |

### Directories

```
.
├── .k8s               # => Kubernetes manifests
│   ├── base             # => base manifests (Service, Deployment, etc...)
│   ├── overlays         # => overlays manifests (Gateway, HTTPRoute, etc...)
│   │   └── local
│   └── (some omitted)
├── api                # => Sample API implementation
└── (some omitted)
```


## Usage

1. Run the application in minikube

    ```shell
    make run
    ```

2. Tunnel from minikube to local environment

    Start another terminal and execute the following.

    ```shell
    make tunnel
    ```

3. Call API

    In addition, start another terminal and execute the following.

    ```shell
    CLUSTER_IP=$(kubectl get gateways gateway -n istio-ingress -o jsonpath='{.status.addresses[*].value}')
    curl -H Host:sample-k8s-gateway-api.localhost.com ${CLUSTER_IP}:8080/api/
    ```

    By adding the cluster ip and host sets to `/etc/hosts`, you can access it from a browser as well.

    - Example of lines to add to `/etc/hosts`

        The `{CLUSTER_IP}` section must be rewritten.

        ```
        {CLUSTER_IP} sample-k8s-gateway-api.localhost.com
        ```

    - URL when accessing with a browser

        http://sample-k8s-gateway-api.localhost.com:8080/api/

4. Stop the application in minikube

    ```shell
    make stop
    ```
