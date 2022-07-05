param vnetId string
param keyvaultName string
param keyvaultNetworkInterfaceId string

var splitId = split(keyvaultNetworkInterfaceId, '/')

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2021-08-01' existing = {
  scope: resourceGroup(splitId[2], splitId[4])
  name: splitId[8]
}

resource azurewebsitesDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
  properties: {}
}

resource portalVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net/${keyvaultName}-vnet-dns-link'
  location: 'global'
  dependsOn: [
    azurewebsitesDnsZone
  ]
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnetId
    }
  }
}

resource functionAppRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net/${keyvaultName}'
  properties: {
    aRecords: [
      {
        ipv4Address: networkInterfaces.properties.ipConfigurations[0].properties.privateIPAddress
      }
    ]
    ttl: 36000
  }

  dependsOn: [
    azurewebsitesDnsZone
  ]
}

resource functionAppScmRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net/${keyvaultName}.scm'
  properties: {
    aRecords: [
      {
        ipv4Address: networkInterfaces.properties.ipConfigurations[0].properties.privateIPAddress
      }
    ]
    ttl: 36000
  }

  dependsOn: [
    azurewebsitesDnsZone
  ]
}
