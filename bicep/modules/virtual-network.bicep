param location string
param baseName string
param environmentCode string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: '${baseName}-vnet-${environmentCode}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/22'
      ]
    }
    subnets: [
      {
        name: '${baseName}-snet-cae-${environmentCode}'
        properties: {
          addressPrefix: '10.50.0.0/23'
          delegations: [
            {
              name: 'Microsoft.App.environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
        }
      }
    ]
  }
}

output caeSubnetId string = virtualNetwork.properties.subnets[0].id
