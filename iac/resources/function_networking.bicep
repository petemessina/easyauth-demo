param vnetId string
param functionAppName string
param functionAppNetworkInterfacesId string

var splitId = split(functionAppNetworkInterfacesId, '/')

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2021-08-01' existing = {
  scope: resourceGroup(splitId[2], splitId[4])
  name: splitId[8]
}

resource azurewebsitesDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'
  properties: {}
}

resource portalVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'privatelink.azurewebsites.net/${functionAppName}-vnet-dns-link'
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

resource logicAppRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: 'privatelink.azurewebsites.net/${functionAppName}'
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

resource logicAppScmRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: 'privatelink.azurewebsites.net/${functionAppName}.scm'
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
