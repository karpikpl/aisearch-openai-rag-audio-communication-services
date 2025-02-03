param name string
param webHookEndpoint string
@secure()
param apiKey string
param tags object = {}

param managedIdentityId string = ''

resource communicationServices 'Microsoft.Communication/communicationServices@2023-06-01-preview' = {
  identity: empty(managedIdentityId)
    ? null
    : {
        type: 'UserAssigned'
        userAssignedIdentities: {
          '${managedIdentityId}': {}
        }
      }
  location: 'global'
  name: name
  properties: {
    dataLocation: 'unitedstates'
    linkedDomains: []
  }
  tags: tags
}

resource eventGridSubscription 'Microsoft.EventGrid/eventSubscriptions@2021-12-01' = {
  name: '${name}-incoming-call'
  scope: communicationServices
  properties: {
    destination: {
      endpointType: 'WebHook'
      properties: {
        maxEventsPerBatch: 1
        endpointUrl: webHookEndpoint
        deliveryAttributeMappings: [
          {
            name: 'x-api-key'
            properties: {
              isSecret: true
              value: apiKey
            }
            type: 'Static'
          }
        ]
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Communication.IncomingCall'
      ]
    }
    retryPolicy: {
      maxDeliveryAttempts: 3
      eventTimeToLiveInMinutes: 5
    }
  }
}

// get communication service connection string
output endpoint string = 'https://${communicationServices.properties.hostName}/'
