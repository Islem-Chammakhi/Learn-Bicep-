param appName string
param location string

resource frontendApplication 'Microsoft.Web/sites@2021-01-15' = {
  name: appName
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
  }
  properties: {
    serverFarmId: 'webServerFarms.id'
  }
}

output frontendName string = frontendApplication.name
