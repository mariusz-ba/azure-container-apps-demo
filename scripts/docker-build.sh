#!/bin/bash

image_tag="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)"

echo "Build docker images: $image_tag"

docker build -f src/Services/AzureContainerApps.ServiceA/Dockerfile -t "$ACR_LOGIN_SERVER/service-a:$image_tag" --platform linux/amd64 .
docker build -f src/Services/AzureContainerApps.ServiceB/Dockerfile -t "$ACR_LOGIN_SERVER/service-b:$image_tag" --platform linux/amd64 .

echo "Docker build complete."
