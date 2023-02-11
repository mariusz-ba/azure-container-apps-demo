# Azure Container Apps

Simple demo showing Azure Container Apps in action.

## Deployment

Use following commands to deploy this demo to Azure.

### Infrastructure

Following bicep template will create necessary resources in resource group `azure-container-apps`.

```shell
./bicep/infrastructure/infrastructure.sh
```

### Docker images

You will need to build and push docker images to container registry.

```shell
az acr login -n <container_registry_name> #eg. academocrmb

export ACR_LOGIN_SERVER=<container_registry_login_server> #eg. academocrmb.azurecr.io

./scripts/docker-build.sh
./scripts/docker-push.sh
```

### Services

Once infrastructure is ready and you have build and pushed docker images, run following command
to deploy services to Azure Container Apps.

```shell
./bicep/services/services.sh
```

### Making changes

Each docker image is tagged with `<branch_name>-<commit_sha>`. When introducing new changes make sure
to commit them first, before building and pushing images to container registry.
