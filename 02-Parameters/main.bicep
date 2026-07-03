@description('The name of the app.')
@maxLength(23)
param appName string

param location string = 'westeurope'

@description('a secure param.')
@secure()
param db_password string 

output result string = '${appName} will be deployed in ${location}'


