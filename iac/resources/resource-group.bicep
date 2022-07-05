param namePrefix string
param location string
param tenantId string

var vaultName = '${namePrefix}-kv-001'
var uniqueStorageName = '${namePrefix}st01'
var functionAppName = '${namePrefix}-func'
var functionAppServicePlanName = '${namePrefix}-func-apps1'
var appInsightsName = '${namePrefix}-ai'
var uniquelogAnalyticsWorkspaceName = '${namePrefix}${uniqueString(resourceGroup().id)}-ws'
var vnetName = '${namePrefix}-vnet'
var keyvaultPrivateEndpointName = '${namePrefix}kv-pe'
var functionPrivateEndpointName = '${namePrefix}func-pe'

module logAnalyticsWorkspace '../modules/loganalytics-workspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    uniquelogAnalyticsWorkspaceName: uniquelogAnalyticsWorkspaceName
    location: location
  }
}

module appInsightsModule '../modules/appinsights_loganalytics.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.logAnalyticsId
  }
}

module vnet '../modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    vnetName: vnetName
    location: location
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'FunctionSubnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
          delegations: [
            {
              name: 'serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      {
        name: 'PrivateEndpointSubnet'
        properties: {
          addressPrefix: '10.0.4.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.5.0/24'
        }
      }
    ]
  }
}

module bastion '../modules/bastion.bicep' = {
  name: 'bastion'
  params: {
    bastionName: 'bastion'
    location: location
    publicIPAddressNameBastion: 'bastionPublicIp'
    bastionIPConfigName: 'bastionIPConfigName'
    subnetId: '${vnet.outputs.id}/subnets/AzureBastionSubnet'
  }
  dependsOn:[
    vnet
  ]
}

module vm_devopswinvm '../modules/buildagent.bicep' = {
  name: 'devopsvm'
  params: {
    location: location
    subnetId: '${vnet.outputs.id}/subnets/default'
    username: 'pmessina'
    password: 'PassW0rd1!'
    vmName: 'devops'
  }
  dependsOn:[
    vnet
  ]
}

module keyVaultResource '../resources/keyvault_resource.bicep' = {
  name: 'keyVaultResource'
  params: {
    vaultName: vaultName
    location: location
    tenantId: tenantId
    vnetId: vnet.outputs.id
    privateEndpointName: keyvaultPrivateEndpointName
    privateEndpointSubnet: '${vnet.outputs.id}/subnets/PrivateEndpointSubnet'
  }
  dependsOn: [
    vnet
  ]
}

module functionAppResource 'function-app.bicep' = {
  name: 'functionAppResource'
  params: {
    functionAppName: functionAppName
    storageAccountName: uniqueStorageName
    location: location
    appServicePlanName: functionAppServicePlanName
    appInsightsInstrKey: appInsightsModule.outputs.appInsightsInstrKey
    keyvaultName: keyVaultResource.outputs.name
    tenantId: tenantId
    vnetId: vnet.outputs.id
    appRegistrationClientId: 'APPREGISTRATIONCLIENTID'
    vnetName: vnet.outputs.name
    virtualNetworkSubnetId: '${vnet.outputs.id}/subnets/FunctionSubnet'
    privateEndpointName: functionPrivateEndpointName
    privateEndpointSubnet: '${vnet.outputs.id}/subnets/PrivateEndpointSubnet'
  }
  dependsOn: [
    vnet
  ]
}
