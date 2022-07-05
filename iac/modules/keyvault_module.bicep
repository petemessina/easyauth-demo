param vaultName string
param location string
param tenantId string
param publicNetworkAccess string = 'Enabled'

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    publicNetworkAccess: publicNetworkAccess
  }
}

output id string = keyVault.id
output name string = vaultName
