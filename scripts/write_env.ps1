# Define the .env file path
$envFilePath = "app\backend\.env"

# Clear the contents of the .env file
Set-Content -Path $envFilePath -Value ""

# Append new values to the .env file
$azureOpenAiEndpoint = azd env get-value AZURE_OPENAI_ENDPOINT
$azureOpenAiRealtimeDeployment = azd env get-value AZURE_OPENAI_REALTIME_DEPLOYMENT
$azureOpenAiRealtimeVoiceChoice = azd env get-value AZURE_OPENAI_REALTIME_VOICE_CHOICE
$azureSearchEndpoint = azd env get-value AZURE_SEARCH_ENDPOINT
$azureSearchIndex = azd env get-value AZURE_SEARCH_INDEX
$azureTenantId = azd env get-value AZURE_TENANT_ID
$azureSearchSemanticConfiguration = azd env get-value AZURE_SEARCH_SEMANTIC_CONFIGURATION
$azureSearchIdentifierField = azd env get-value AZURE_SEARCH_IDENTIFIER_FIELD
$azureSearchTitleField = azd env get-value AZURE_SEARCH_TITLE_FIELD
$azureSearchContentField = azd env get-value AZURE_SEARCH_CONTENT_FIELD
$azureSearchEmbeddingField = azd env get-value AZURE_SEARCH_EMBEDDING_FIELD
$azureSearchUseVectorQuery = azd env get-value AZURE_SEARCH_USE_VECTOR_QUERY
$acsEndpoint = azd env get-value ACS_ENDPOINT
$backendUri = azd env get-value BACKEND_URI
$callAutomationUri = azd env get-value CALLAUTOMATION_URI

Add-Content -Path $envFilePath -Value "AZURE_OPENAI_ENDPOINT=$azureOpenAiEndpoint"
Add-Content -Path $envFilePath -Value "AZURE_OPENAI_REALTIME_DEPLOYMENT=$azureOpenAiRealtimeDeployment"
Add-Content -Path $envFilePath -Value "AZURE_OPENAI_REALTIME_VOICE_CHOICE=$azureOpenAiRealtimeVoiceChoice"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_ENDPOINT=$azureSearchEndpoint"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_INDEX=$azureSearchIndex"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_SEMANTIC_CONFIGURATION=$azureSearchSemanticConfiguration"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_IDENTIFIER_FIELD=$azureSearchIdentifierField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_TITLE_FIELD=$azureSearchTitleField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_CONTENT_FIELD=$azureSearchContentField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_EMBEDDING_FIELD=$azureSearchEmbeddingField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_USE_VECTOR_QUERY=$azureSearchUseVectorQuery"
Add-Content -Path $envFilePath -Value "AZURE_TENANT_ID=$azureTenantId"
Add-Content -Path $envFilePath -Value "ACS_ENDPOINT=$acsEndpoint"
Add-Content -Path $envFilePath -Value "# Change this variable for local development"
Add-Content -Path $envFilePath -Value "CALLBACK_URI_HOST=$backendUri"

# other file
# Define the .env file path
$envFilePath = "callautomation-azure-openai-voice\.env"

# Clear the contents of the .env file
Set-Content -Path $envFilePath -Value ""

Add-Content -Path $envFilePath -Value "AZURE_OPENAI_ENDPOINT=$azureOpenAiEndpoint"
Add-Content -Path $envFilePath -Value "AZURE_OPENAI_REALTIME_DEPLOYMENT=$azureOpenAiRealtimeDeployment"
Add-Content -Path $envFilePath -Value "AZURE_OPENAI_REALTIME_VOICE_CHOICE=$azureOpenAiRealtimeVoiceChoice"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_ENDPOINT=$azureSearchEndpoint"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_INDEX=$azureSearchIndex"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_SEMANTIC_CONFIGURATION=$azureSearchSemanticConfiguration"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_IDENTIFIER_FIELD=$azureSearchIdentifierField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_TITLE_FIELD=$azureSearchTitleField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_CONTENT_FIELD=$azureSearchContentField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_EMBEDDING_FIELD=$azureSearchEmbeddingField"
Add-Content -Path $envFilePath -Value "AZURE_SEARCH_USE_VECTOR_QUERY=$azureSearchUseVectorQuery"
Add-Content -Path $envFilePath -Value "AZURE_TENANT_ID=$azureTenantId"
Add-Content -Path $envFilePath -Value "ACS_ENDPOINT=$acsEndpoint"
Add-Content -Path $envFilePath -Value "# Change this variable for local development"
Add-Content -Path $envFilePath -Value "CALLBACK_URI_HOST=$callAutomationUri"