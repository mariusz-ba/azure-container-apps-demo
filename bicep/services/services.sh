#!/bin/bash

image_tag="$(git rev-parse --abbrev-ref HEAD | sed 's/\//-/')-$(git rev-parse --short HEAD)"

echo "Starting services deployment."

az deployment group create \
  --resource-group azure-container-apps \
  --template-file bicep/services/services.bicep \
  --parameters bicep/services/services.params.json \
  --parameters productsServiceImage="products:$image_tag" \
  --parameters ordersServiceImage="orders:$image_tag" \
  --parameters gatewayImage="gateway:$image_tag"

echo "Services deployment complete."