#!/bin/bash

image_tag="$(git rev-parse --abbrev-ref HEAD)-$(git rev-parse --short HEAD)"

echo "Starting services deployment."

az deployment group create \
  --resource-group azure-container-apps \
  --template-file bicep/services/services.bicep \
  --parameters bicep/services/services.params.json \
  --parameters serviceAImage="service-a:$image_tag" \
  --parameters serviceBImage="service-b:$image_tag"

echo "Services deployment complete."