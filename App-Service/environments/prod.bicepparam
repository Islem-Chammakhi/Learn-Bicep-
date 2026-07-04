using '../main.bicep'

param env = 'prod'
param project = 'immobox'
param appServicePlankind = 'linux'
param appServicePlanSkuName ='B1'
param appServicePlanCapacity = 1 
param appServicePlanTags = {
  Environment: env
  Project: 'Immobox'
}
param appServiceTags = {
  Environment: env
  Project: project
}
