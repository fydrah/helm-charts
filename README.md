# Helm charts collection

## Repository

Helm charts are currently hosted on GitHub releases

```shell
helm repo add fydrah https://raw.githubusercontent.com/fydrah/helm-charts/master/index.yaml
helm repo update
```

## Charts

Available charts:

* [Plex](./plex)

    ```shell
    helm install fydrah/plex
    ```

* [Transmission](./transmission)

    ```shell
    helm install fydrah/transmission
    ```

## Contributors

### Upload a chart

**repo admin only**

1. Update chart `version` (and `appVersion` if necessary) in `Chart.yaml` file
2. Make sure you have:

    * [yq](https://github.com/mikefarah/yq/releases/latest)
    * [helm chart-releaser](https://github.com/helm/chart-releaser/releases/latest)

3. Export variables

    ```shell
    export CR_INDEX_PATH=index.yaml
    export CR_CHARTS_REPO=https://github.com/fydrah/helm-charts
    export CR_GIT_REPO=helm-charts
    export CR_PACKAGE_PATH=.deploy
    export CR_OWNER=fydrah
    export CR_TOKEN=REDACTED   # This must be a github token with *repos* privileges
    ```
4. Deploy releases. This will package, tag and push tags, and index latest versions.
   This does not push produced **index.yaml** (to avoid indexation of wrong release):

    ```shell
    # Launch this from root directory
    ./scripts/deploy-charts.sh
    ```
