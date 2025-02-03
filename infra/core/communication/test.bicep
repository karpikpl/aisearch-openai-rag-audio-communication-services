targetScope = 'resourceGroup'

module communicationServices 'services.bicep' = {
  name: 'communication-service-pka2'
  params: {
    name: 'communication-service-pka2'
    webHookEndpoint: 'https://webhook.com'
    apiKey: guid(resourceGroup().id, 'communication-service-pka2')
  }
}
