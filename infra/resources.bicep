param location string

resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: 'acr${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output ACR_NAME string = acr.name
