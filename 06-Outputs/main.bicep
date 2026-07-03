resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: 'st${uniqueString('examplestorage123')}'
  location: 'westeurope'

  sku: {
    name: 'Standard_LRS'
  }

  kind: 'StorageV2'
}

output storageName string = storage.name
