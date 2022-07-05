param privateEndpointName string
param location string
param subnetId string
param privateLinkServiceId string
param privateLinkServiceGroupIds array

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: privateLinkServiceGroupIds
        }
      }
    ]
  }
}

output networkInterfacesId string = privateEndpoint.properties.networkInterfaces[0].id
