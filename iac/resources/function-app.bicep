param functionAppName string
param tenantId string
param storageAccountName string
param location string
param appInsightsInstrKey string
param appServicePlanName string
param keyvaultName string
param appRegistrationClientId string
param vnetName string
param virtualNetworkSubnetId string
param privateEndpointName string
param privateEndpointSubnet string
param vnetId string

module stgModule '../modules/storage.bicep' = {
  name: 'storageDeploy'
  params: {
    storageAccountName: storageAccountName
    location: location
    fileShareName: functionAppName
  }
}

module funcAppServicePlan '../modules/appservice_plan.bicep' = {
  name: 'funcAppServicePlan'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    sku: 'EP1'
    tier: 'ElasticPremium'
    kind: 'elastic'
    reserved: true
  }
}

module functionAppModule '../modules/function.bicep'= {
  name: 'functionAppModule'
  params: {
    functionAppName: functionAppName
    location: location
    appInsightsInstrumentationKey: appInsightsInstrKey
    appServicePlanExtId: funcAppServicePlan.outputs.appServicePlanId
    storageConnectionString: stgModule.outputs.storageConnectionString
  }
  dependsOn: [
    stgModule
    funcAppServicePlan
  ]
}

module appServiceAuthSettings '../modules/appservice_authsettings.bicep' = {
  name: 'appServiceAuthSettings'
  params: {
    functionAppName: functionAppModule.outputs.name
    tenantId: tenantId
    appRegistrationClientId: appRegistrationClientId
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyvaultName
}

resource secret_heimdall_azure_sp_clientid 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'test'
  properties: {
    attributes: {
      enabled: true
    }
    value: 'Hello World'
  }
}

resource roleAssignment'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('function-secretreader-clientid1')
  scope: keyVault
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6'
    principalId: functionAppModule.outputs.servicePrincipalId
    principalType: 'ServicePrincipal'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
}

resource networkConfig 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${functionAppName}/virtualNetwork'
  properties: {
    subnetResourceId: virtualNetworkSubnetId
    swiftSupported: true
  }
  dependsOn:[
    functionAppModule
  ]
}

module keyvaulltPrivateEndPoint '../modules/private-endpoint.bicep' = {
  name: 'keyvaulltPrivateEndPoint'
  params: {
    privateEndpointName: privateEndpointName
    location: location
    subnetId: privateEndpointSubnet
    privateLinkServiceId: functionAppModule.outputs.id
    privateLinkServiceGroupIds: [
      'sites'
    ]
  }
  dependsOn:[
    keyVault
  ]
}

module functionPrivateDnsZone 'function_networking.bicep' = {
  name: 'functionPrivateDnsZone'
  params: {
    vnetId: vnetId
    functionAppName: functionAppModule.outputs.name
    functionAppNetworkInterfacesId: keyvaulltPrivateEndPoint.outputs.networkInterfacesId
  }
  dependsOn:[
    functionAppModule
  ]
}

output name string = functionAppModule.outputs.name
