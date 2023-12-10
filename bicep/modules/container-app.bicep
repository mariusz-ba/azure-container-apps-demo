param location string
param environmentId string
param containerAppName string
param containerImage string
param containerPort int
param isExternalIngress bool = false
param environmentVars array = []
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string

@secure()
param configurationSecrets object = {}

param resources object = {
  cpu: '0.5'
  memory: '1.0Gi'
}

param scale object = {
  minReplicas: 0
  maxReplicas: 1
}

var commonSecrets = [
  {
    name: 'registry-password'
    value: containerRegistryPassword
  }
]

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    configuration: {
      secrets: empty(configurationSecrets) ? commonSecrets : concat(commonSecrets, configurationSecrets.secrets)
      registries: [
        {
          server: containerRegistry
          username: containerRegistryUsername
          passwordSecretRef: 'registry-password'
        }
      ]
      ingress: {
        external: isExternalIngress
        targetPort: containerPort
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: containerAppName
          env: environmentVars
          resources: resources
        }
      ]
      scale: scale
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
