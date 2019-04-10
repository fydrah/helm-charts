# Helm charts collection

## Repository

Helm charts are currently hosted at https://charts.fhardy.fr

```shell
helm repo add fhardy https://charts.fhardy.fr
helm repo update
```

## Charts

Available charts:

* [Plex](./plex)

    ```shell
    helm install fhardy/plex
    ```

* [Transmission](./transmission)

    ```shell
    helm install fhardy/transmission
    ```

## Contributors


### Upload a chart

1. Update chart `version` (and `appVersion` if necessary) in `Chart.yaml` file
2. Make sure you have [helm push](https://github.com/chartmuseum/helm-push#install) plugin installed
3. Create a credentials file:

    ```shell
    $  cat ~/.helm/push-fhardy.sh
    #!/bin/bash

    export HELM_REPO_USERNAME=USERNAME
    export HELM_REPO_PASSWORD=PASSWORD
    ```
4. Source it and push:

    ```shell
    $ source ~/.helm/push-fhardy.sh
    $ export CHART_PATH=$(pwd)
    $ helm push $CHART_PATH fhardy
    ```
