param functionAppName string
param tenantId string
param appRegistrationClientId string

resource functionApp 'Microsoft.Web/sites@2020-06-01' existing = {
  name: functionAppName
}

resource authSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'authsettingsV2'
  parent: functionApp
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'Return401'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          clientId: appRegistrationClientId
          openIdIssuer: 'https://sts.windows.net/${tenantId}/v2.0'
          clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
        }
        validation: {
          allowedAudiences: [
            'api://${appRegistrationClientId}'
          ]
        }
      }
    }
  }
}
