
param name string
param location string
param appServicePlankind string ='linux'

@allowed([
  'B1'
  'S1'
  'P1v3'
])
param appServicePlanSkuName string ='B1'
param appServicePlanCapacity int
param appServicePlanTags object = {}
resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: name
  location: location
  kind:appServicePlankind
  sku:{
    name:appServicePlanSkuName
    capacity:appServicePlanCapacity
  }
  
  tags:appServicePlanTags
  
}


output servicePlanId string = appServicePlan.id
output servicePlanName string = appServicePlan.name
