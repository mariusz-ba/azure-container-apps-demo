#!/bin/bash

image_tag="$(git rev-parse --abbrev-ref HEAD | sed 's/\//-/')-$(git rev-parse --short HEAD)"

echo "Push docker images: $image_tag"

docker push "$ACR_LOGIN_SERVER/gateway:$image_tag"
docker push "$ACR_LOGIN_SERVER/products:$image_tag"
docker push "$ACR_LOGIN_SERVER/orders:$image_tag"

echo "Docker push complete."
