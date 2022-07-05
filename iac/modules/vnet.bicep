param vnetName string
param location string
param addressPrefixes array
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: subnets
  }
}

output subnets array = vnet.properties.subnets
output id string = vnet.id
output name string = vnet.name
