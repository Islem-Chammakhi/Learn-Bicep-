using '../main.bicep'

param env = 'accept'
param project = 'immobox'
param appServicePlankind = 'linux'
param appServicePlanSkuName ='B1'
param appServicePlanCapacity = 1 
param appServicePlanTags = {
  Environment: env
  Project: project
}
param appServiceTags = {
  Environment: env
  Project: project
}

