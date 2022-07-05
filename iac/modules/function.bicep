param functionAppName string
param location string
param storageConnectionString string
param appServicePlanExtId string
param appInsightsInstrumentationKey string

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlanExtId
    clientAffinityEnabled: true    
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsightsInstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: storageConnectionString
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~4'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'java'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageConnectionString
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}

output id string = functionApp.id
output name string = functionAppName
output servicePrincipalId string = functionApp.identity.principalId
