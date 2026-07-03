resource plan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: 'my-plan'
  location: 'westeurope'

  sku: {
    name: 'B1'
  }
}

resource app 'Microsoft.Web/sites@2025-03-01' = {
  name: 'my-api'
  location: 'westeurope'

  properties: {
    serverFarmId: plan.id
  }
}
