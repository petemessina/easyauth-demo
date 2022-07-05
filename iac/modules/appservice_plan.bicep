param appServicePlanName string
param location string
param sku string
param tier string
param reserved bool = false

@allowed([
  'windows'
  'linux'
  'elastic'
])
param kind string = 'linux'

resource appServicePlan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    tier: tier
  }
  kind: kind
  properties: {
    reserved: reserved
   }
}

output appServicePlanId string = appServicePlan.id
