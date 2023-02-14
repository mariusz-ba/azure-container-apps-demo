param location string = resourceGroup().location
param baseName string = 'aca-demo'
param environmentCode string

module containerRegistry '../modules/container-registry.bicep' = {
  name: 'container-registry'
  params: {
    location: location
    baseName: baseName
    environmentCode: environmentCode
  }
}
