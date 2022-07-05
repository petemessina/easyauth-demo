param vaultName string
param location string
param tenantId string
param privateEndpointName string
param privateEndpointSubnet string
param vnetId string

module keyVault '../modules/keyvault_module.bicep' = {
  name: 'keyVault'
  params: {
    vaultName: vaultName
    location: location
    tenantId: tenantId
    publicNetworkAccess: 'Disabled'
  }
}

module keyvaulltPrivateEndPoint '../modules/private-endpoint.bicep' = {
  name: 'keyvaulltPrivateEndPoint'
  params: {
    privateEndpointName: privateEndpointName
    location: location
    subnetId: privateEndpointSubnet
    privateLinkServiceId: keyVault.outputs.id
    privateLinkServiceGroupIds: [
      'vault'
    ]
  }
  dependsOn:[
    keyVault
  ]
}

module keyvaultPrivateDnsZone 'keyvault_networking.bicep' = {
  name: 'keyvaultPrivateDnsZone'
  params: {
    vnetId: vnetId
    keyvaultName: keyVault.outputs.name
    keyvaultNetworkInterfaceId: keyvaulltPrivateEndPoint.outputs.networkInterfacesId
  }
  dependsOn:[
    keyVault
  ]
}

output name string = keyVault.outputs.name
