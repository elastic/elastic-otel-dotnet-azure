#!/bin/sh
set -e

# Make sure az commands use the same subscription
az account set -s $AZURE_SUBSCRIPTION_ID

printf "Building and uploading elastic-otel-collector image to $ACR_NAME. Please wait..."
az acr build --resource-group $GROUP_NAME \
  --registry $ACR_NAME \
  --image elastic-otel-collector-azure:latest \
  --file images/elastic-otel-collector/Dockerfile \
  --platform linux/amd64 \
  --output none \
  images/elastic-otel-collector
printf "Success!\n"


printf "Building and uploading dotnet-api image to $ACR_NAME. Please wait..."
az acr build --resource-group $GROUP_NAME \
  --registry $ACR_NAME \
  --image dotnet-api:latest \
  --file images/dotnet-api/Dockerfile \
  --platform linux/amd64 \
  --output none \
  images/dotnet-api
printf "Success!\n"
