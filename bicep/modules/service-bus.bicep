param location string
param baseName string
param environmentCode string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: '${baseName}-ns-${environmentCode}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }

  resource containerAppsAuthorizationRule 'AuthorizationRules@2021-11-01' = {
    name: 'ContainerAppsAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
}
