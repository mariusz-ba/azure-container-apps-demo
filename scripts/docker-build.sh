#!/bin/bash

image_tag="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)"

echo "Build docker images: $image_tag"

docker build -f src/Services/AzureContainerApps.Products/Dockerfile -t "$ACR_LOGIN_SERVER/products:$image_tag" --platform linux/amd64 .
docker build -f src/Services/AzureContainerApps.Orders/Dockerfile -t "$ACR_LOGIN_SERVER/orders:$image_tag" --platform linux/amd64 .

echo "Docker build complete."
