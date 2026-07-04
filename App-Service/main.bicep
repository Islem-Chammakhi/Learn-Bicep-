
param appName string = uniqueString(resourceGroup().id)
param location string = resourceGroup().location
param appServicePlankind string 
param env string
param project string

@allowed([
  'B1'
  'S1'
  'P1v3'
])
param appServicePlanSkuName string ='B1'
param appServicePlanCapacity int
param appServicePlanTags object = {}
param appServiceTags object = {}
var appServicePlanDeplomentName = toLower('${project}_app_service_plan_deployment_${env}-${appName}')
var appServicePlanName string = toLower('${project}_app_service_plan_${env}-${appName}')
var appServicesList array = [
  {
    name : 'app_service_api_${env}'
    linuxFxVersion : 'DOTNETCORE|8.0'
  }
  {
    name : 'app_service_ai_${env}'
    linuxFxVersion : 'PYTHON|3.12'
  }
]

@description('service plan that contains AI and API application')
module appServicePlan 'modules/app-service-plan.bicep'= {
  name: appServicePlanDeplomentName
  params:{
    name:appServicePlanName
    location:location
    appServicePlankind:appServicePlankind
    appServicePlanSkuName:appServicePlanSkuName
    appServicePlanCapacity:appServicePlanCapacity
    appServicePlanTags:appServicePlanTags
  }
}


module appServices 'modules/app-service.bicep' = [for item in appServicesList: {
  name: '${item.name}_deployment'
  params:{
    name: item.name
    linuxFxVersion: item.linuxFxVersion
    location:location
    webServerFarmsId: appServicePlan.outputs.servicePlanId
    tags:appServiceTags
    alwaysOn: env=='prod' ? true : false 
    http20Enabled:env=='prod' ? true : false
  }
}]
