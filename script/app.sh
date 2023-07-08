#!/bin/bash

if [ "x$1" = "xrun" ]; then
    if [ ! -d "$HOME/.minikube/machines/$PROJECT_NAME" ]; then
        # Initial startup
        minikube start --driver=virtualbox --profile "$PROJECT_NAME"
        # Apply CRD for Gateway API
        kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v0.7.1/standard-install.yaml
    else
        # On second or subsequent startup
        minikube start --driver=virtualbox --profile "$PROJECT_NAME"
    fi
    # Skaffold startup
    skaffold dev

elif [ "x$1" = "xtunnel" ]; then
    minikube tunnel --profile "$PROJECT_NAME"

elif [ "x$1" = "xstop" ]; then
    skaffold delete
    minikube stop --profile "$PROJECT_NAME"

elif [ "x$1" = "xlogs" ]; then
    NAMESPACES=("sample-k8s-gateway-api")
    for NS in ${NAMESPACES[@]}; do
        POD_NAME=$(kubectl get pods -o custom-columns=":metadata.name" -n "$NS" | grep "$2")
        if [ "$POD_NAME" != "" ]; then
            echo "[namespace: $NS, pod: $POD_NAME] logs..."
            kubectl logs "$POD_NAME" -n "$NS"
        fi
    done

elif [ "x$1" = "xdashboard" ]; then
    minikube dashboard -p "$PROJECT_NAME"

elif [ "x$1" = "xdestroy" ]; then
    minikube delete --profile "$PROJECT_NAME"

else
    echo "You have to specify which action to be excuted. [ run / tunnel / stop / logs / dashboard / destroy ]" 1>&2
    exit 1
fi
