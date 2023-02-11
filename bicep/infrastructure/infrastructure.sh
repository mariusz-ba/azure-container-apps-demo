#!/bin/bash

echo "Starting infrastructure deployment."

az deployment group create \
  --resource-group azure-container-apps \
  --template-file bicep/infrastructure/infrastructure.bicep \
  --parameters bicep/infrastructure/infrastructure.params.json

echo "Infrastructure deployment complete."
