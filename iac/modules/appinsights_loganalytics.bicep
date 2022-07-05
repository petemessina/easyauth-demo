param appInsightsName string
param location string
param logAnalyticsWorkspaceId string

resource appinsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

output appInsightsName string = appinsights.name
output appInsightsId string = appinsights.id
output appInsightsInstrKey string = appinsights.properties.InstrumentationKey
output appInsightsEndpoint string = appinsights.properties.ConnectionString
