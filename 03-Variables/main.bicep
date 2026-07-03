param project string

@description('The environment to deploy to')
@allowed(['dev', 'test', 'prod'])
param env string = 'dev'

var prefix = '${project}-${env}'

var backend = '${prefix}-backend'
var frontend = '${prefix}-frontend'

output backendName string = backend
output frontendName string = frontend
