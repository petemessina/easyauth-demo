param bastionName string
param location string
param publicIPAddressNameBastion string
param bastionIPConfigName string
param subnetId string

resource pipBastion 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: publicIPAddressNameBastion
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2020-07-01' = {
  name: bastionName
  location: location 
  properties: {
    ipConfigurations: [
      {
        name: bastionIPConfigName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pipBastion.id             
          }
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
} 
