param uniquelogAnalyticsWorkspaceName string
param location string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: uniquelogAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output logAnalyticsId string = logAnalyticsWorkspace.id
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
