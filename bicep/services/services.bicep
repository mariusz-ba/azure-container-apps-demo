param location string = resourceGroup().location
param baseName string = 'aca-demo'
param environmentCode string

param productsServiceImage string
param ordersServiceImage string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-12-01' existing = {
  name: '${replace(baseName, '-', '')}cr${environmentCode}'
}

module containerAppEnvironment '../modules/container-app-environment.bicep' = {
  name: 'environment'
  params: {
    location: location
    baseName: baseName
    environmentCode: environmentCode
  }
}

var commonEnvironmentVariables = [
  {
    name: 'ASPNETCORE_ENVIRONMENT'
    value: 'Production'
  }
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: containerAppEnvironment.outputs.appInsightsInstrumentationKey
  }
  {
    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
    value: containerAppEnvironment.outputs.appInsightsConnectionString
  }
]

module productsService '../modules/container-app.bicep' = {
  name: 'products-service'
  params: {
    location: location
    environmentId: containerAppEnvironment.outputs.id
    containerAppName: '${baseName}-products-${environmentCode}'
    containerRegistry: containerRegistry.properties.loginServer
    containerRegistryUsername: containerRegistry.listCredentials().username
    containerRegistryPassword: containerRegistry.listCredentials().passwords[0].value
    containerImage: '${containerRegistry.properties.loginServer}/${productsServiceImage}'
    containerPort: 80
    isExternalIngress: true
    environmentVars: commonEnvironmentVariables
  }
}

module ordersService '../modules/container-app.bicep' = {
  name: 'orders-service'
  params: {
    location: location
    environmentId: containerAppEnvironment.outputs.id
    containerAppName: '${baseName}-orders-${environmentCode}'
    containerRegistry: containerRegistry.properties.loginServer
    containerRegistryUsername: containerRegistry.listCredentials().username
    containerRegistryPassword: containerRegistry.listCredentials().passwords[0].value
    containerImage: '${containerRegistry.properties.loginServer}/${ordersServiceImage}'
    containerPort: 80
    isExternalIngress: true
    environmentVars: commonEnvironmentVariables
  }
}
