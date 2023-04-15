#!/bin/bash

az containerapp up \
  --name aca-demo-nginx-mb \
  --resource-group azure-container-apps-nginx \
  --location westeurope \
  --environment aca-demo-nginx-env-mb \
  --image nginx:latest \
  --target-port 80 \
  --ingress external \
  --query properties.configuration.ingress.fqdn
