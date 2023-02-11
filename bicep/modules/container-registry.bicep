param location string
param baseName string
param environmentCode string

resource acr 'Microsoft.ContainerRegistry/registries@2022-12-01' = {
  name: '${replace(baseName, '-', '')}cr${environmentCode}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}
