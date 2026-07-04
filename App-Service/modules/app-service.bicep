param name string
param location string
param tags object
param webServerFarmsId string
param linuxFxVersion string
param alwaysOn bool 
param http20Enabled bool 

resource appService 'Microsoft.Web/sites@2025-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    serverFarmId: webServerFarmsId
    siteConfig: {
      linuxFxVersion:linuxFxVersion
      alwaysOn: alwaysOn
      http20Enabled: http20Enabled
      
    }
    httpsOnly:true
    
  }
  
}

output appServiceId string = appService.id
output appServiceName string = appService.name
