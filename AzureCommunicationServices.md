# Azure Communication Services with VoiceRAG: Call your chat sample

Sample connects Azure Communication Services with [VoiceRAG](README.md) to provide users ability to call 800 number to talk with the model.

## Projects

Sample shows how to open two web socket connections, first to provide to Azure Communication Services (ACS) when answering incoming call, second one with OpenAI (OAI) realtime API.

Application code translates web socket messages between OAI model and ACS.

### callautomation-azure-openai-voice

Project uses [rtclient-0.5.1-py3-none-any](https://github.com/Azure-Samples/aoai-realtime-audio-sdk/releases) to communication with OpenAI realtime API.

Application uses weather function to read current forecast information.

### app/backend

Backend app exposes two API for two WebSocket connections - one for the web, second one for ACS.

## Deployment

Deploy to Azure using `azd up` and following instructions [here](./README.md#deploying-the-app).

> [!WARNING]
> After deploying the infrastructure, to to Azure Communication Services and either buy a phone number ($2 / month) or start a free trial.

> [!INFO]
> By default deployment configures ACS with `app/backend` application. To change how incoming call is handled
> go to ACS -> Events -> incoming call webhook -> change the endpoint to either `call automation`, `backend` apps or devtunnel host when in local development.

## Local development

When running locally, use devtunnel to expose your local API to the cloud.

[Azure DevTunnels](https://learn.microsoft.com/en-us/azure/developer/dev-tunnels/overview) is an Azure service that enables you to share local web services hosted on the internet. Use the commands below to connect your local development environment to the public internet. This creates a tunnel with a persistent endpoint URL and which allows anonymous access. We will then use this endpoint to notify your application of calling events from the ACS Call Automation service.

```bash
devtunnel user login
devtunnel create --allow-anonymous
devtunnel port create -p 8080
devtunnel host
```

> [!INFO]
> Use the port for devtunnel that the app is using locally!

> [!WARNING]
> Add `CALLBACK_URI_HOST`: Base url of the app. (For local development use dev tunnel url) to `.env` files.

## Resources

* [GPT-4o-Realtime Best Practices](https://techcommunity.microsoft.com/blog/azure-ai-services-blog/voice-bot-gpt-4o-realtime-best-practices---a-learning-from-customer-journey/4373584)
* [Building voice bot](https://techcommunity.microsoft.com/blog/azure-ai-services-blog/my-journey-of-building-a-voice-bot-from-scratch/4362567)
* [openai realtime api-beta client](https://github.com/openai/openai-realtime-api-beta)