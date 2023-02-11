param location string
param baseName string
param environmentCode string

resource logsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${baseName}-logs-${environmentCode}'
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${baseName}-ai-${environmentCode}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logsWorkspace.id
  }
}

resource env 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: '${baseName}-env-${environmentCode}'
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logsWorkspace.properties.customerId
        sharedKey: logsWorkspace.listKeys().primarySharedKey
      }
    }
  }
}

output id string = env.id
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString
