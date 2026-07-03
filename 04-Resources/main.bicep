@onlyIfNotExists()
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: 'mystorage123'
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }

  kind: 'StorageV2'
}

var storage_name = ['s1','s2','s3','s4','s5','s6','s7','s8',]

resource name 'Microsoft.Storage/storageAccounts@2021-02-01' = [ for stg in storage_name: {
  
  name: stg
  location: stg
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }

}]

output storage_name string = storage.name == 'islem' ? 'islem' : storage.name 
