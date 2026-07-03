module backend 'modules/backend.bicep' = {
  name: 'backendModule'
  params: {
    appName: 'esg-backend'
    location: 'westeurope'
  }
}

module frontend 'modules/frontend.bicep' = {
  name: 'frontendModule'
  params: {
    appName: 'esg-frontend'
    location: 'westeurope'
  }
}

output backendName string = backend.outputs.backendName
output frontendName string = frontend.outputs.frontendName
