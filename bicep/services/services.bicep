param location string = resourceGroup().location
param baseName string = 'aca-demo'
param environmentCode string

param serviceAImage string
param serviceBImage string

resource serviceBusAuthorizationRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' existing = {
  name: '${baseName}-ns-${environmentCode}/ContainerAppsAccessKey'
}

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
  {
    name: 'AzureServiceBus__ConnectionString'
    secretRef: 'service-bus-connection-string'
  }
]

module serviceA '../modules/container-app.bicep' = {
  name: 'service-a'
  params: {
    location: location
    environmentId: containerAppEnvironment.outputs.id
    containerAppName: '${baseName}-service-a-${environmentCode}'
    containerRegistry: containerRegistry.properties.loginServer
    containerRegistryUsername: containerRegistry.listCredentials().username
    containerRegistryPassword: containerRegistry.listCredentials().passwords[0].value
    containerImage: '${containerRegistry.properties.loginServer}/${serviceAImage}'
    containerPort: 80
    isExternalIngress: true
    environmentVars: commonEnvironmentVariables
    configurationSecrets: {
      secrets: [
        {
          name: 'service-bus-connection-string'
          value: serviceBusAuthorizationRule.listKeys().primaryConnectionString
        }
      ]
    }
  }
}

module serviceB '../modules/container-app.bicep' = {
  name: 'service-b'
  params: {
    location: location
    environmentId: containerAppEnvironment.outputs.id
    containerAppName: '${baseName}-service-b-${environmentCode}'
    containerRegistry: containerRegistry.properties.loginServer
    containerRegistryUsername: containerRegistry.listCredentials().username
    containerRegistryPassword: containerRegistry.listCredentials().passwords[0].value
    containerImage: '${containerRegistry.properties.loginServer}/${serviceBImage}'
    containerPort: 80
    isExternalIngress: true
    environmentVars: commonEnvironmentVariables
    configurationSecrets: {
      secrets: [
        {
          name: 'service-bus-connection-string'
          value: serviceBusAuthorizationRule.listKeys().primaryConnectionString
        }
      ]
    }
  }
}