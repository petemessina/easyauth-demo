targetScope = 'subscription'

@minLength(3)
@maxLength(11)
param namePrefix string = 'testpm2'
param location string = deployment().location

var resourceGroupName = '${namePrefix}-rg-001'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resources 'resources/resource-group.bicep' = {
  name: 'resources'
  scope: resourceGroup
  params: {
    namePrefix: namePrefix
    location: location
    tenantId: tenant().tenantId
  }
}
