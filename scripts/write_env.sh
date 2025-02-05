#!/bin/bash

# Define the .env file path
ENV_FILE_PATH="app/backend/.env"

# Clear the contents of the .env file
> $ENV_FILE_PATH

# Append new values to the .env file
echo "AZURE_OPENAI_ENDPOINT=$(azd env get-value AZURE_OPENAI_ENDPOINT)" >> $ENV_FILE_PATH
echo "AZURE_OPENAI_REALTIME_DEPLOYMENT=$(azd env get-value AZURE_OPENAI_REALTIME_DEPLOYMENT)" >> $ENV_FILE_PATH
echo "AZURE_OPENAI_REALTIME_VOICE_CHOICE=$(azd env get-value AZURE_OPENAI_REALTIME_VOICE_CHOICE)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_ENDPOINT=$(azd env get-value AZURE_SEARCH_ENDPOINT)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_INDEX=$(azd env get-value AZURE_SEARCH_INDEX)" >> $ENV_FILE_PATH
echo "AZURE_TENANT_ID=$(azd env get-value AZURE_TENANT_ID)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_SEMANTIC_CONFIGURATION=$(azd env get-value AZURE_SEARCH_SEMANTIC_CONFIGURATION)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_IDENTIFIER_FIELD=$(azd env get-value AZURE_SEARCH_IDENTIFIER_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_CONTENT_FIELD=$(azd env get-value AZURE_SEARCH_CONTENT_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_TITLE_FIELD=$(azd env get-value AZURE_SEARCH_TITLE_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_EMBEDDING_FIELD=$(azd env get-value AZURE_SEARCH_EMBEDDING_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_USE_VECTOR_QUERY=$(azd env get-value AZURE_SEARCH_USE_VECTOR_QUERY)" >> $ENV_FILE_PATH
echo "ACS_ENDPOINT=$(azd env get-value ACS_ENDPOINT)" >> $ENV_FILE_PATH
echo "# Change this variable for local development" >> $ENV_FILE_PATH
echo "CALLBACK_URI_HOST=$(azd env get-value BACKEND_URI)" >> $ENV_FILE_PATH

# second env file
# Define the .env file path
ENV_FILE_PATH="callautomation-azure-openai-voice/.env"

# Clear the contents of the .env file
> $ENV_FILE_PATH

# Append new values to the .env file
echo "AZURE_OPENAI_ENDPOINT=$(azd env get-value AZURE_OPENAI_ENDPOINT)" >> $ENV_FILE_PATH
echo "AZURE_OPENAI_REALTIME_DEPLOYMENT=$(azd env get-value AZURE_OPENAI_REALTIME_DEPLOYMENT)" >> $ENV_FILE_PATH
echo "AZURE_OPENAI_REALTIME_VOICE_CHOICE=$(azd env get-value AZURE_OPENAI_REALTIME_VOICE_CHOICE)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_ENDPOINT=$(azd env get-value AZURE_SEARCH_ENDPOINT)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_INDEX=$(azd env get-value AZURE_SEARCH_INDEX)" >> $ENV_FILE_PATH
echo "AZURE_TENANT_ID=$(azd env get-value AZURE_TENANT_ID)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_SEMANTIC_CONFIGURATION=$(azd env get-value AZURE_SEARCH_SEMANTIC_CONFIGURATION)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_IDENTIFIER_FIELD=$(azd env get-value AZURE_SEARCH_IDENTIFIER_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_CONTENT_FIELD=$(azd env get-value AZURE_SEARCH_CONTENT_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_TITLE_FIELD=$(azd env get-value AZURE_SEARCH_TITLE_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_EMBEDDING_FIELD=$(azd env get-value AZURE_SEARCH_EMBEDDING_FIELD)" >> $ENV_FILE_PATH
echo "AZURE_SEARCH_USE_VECTOR_QUERY=$(azd env get-value AZURE_SEARCH_USE_VECTOR_QUERY)" >> $ENV_FILE_PATH
echo "ACS_ENDPOINT=$(azd env get-value ACS_ENDPOINT)" >> $ENV_FILE_PATH
echo "# Change this variable for local development" >> $ENV_FILE_PATH
echo "CALLBACK_URI_HOST=$(azd env get-value CALLAUTOMATION_URI)" >> $ENV_FILE_PATH