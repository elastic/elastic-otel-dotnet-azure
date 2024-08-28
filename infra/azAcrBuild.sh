#!/bin/sh
set -e

# Make sure az commands use the same subscription
az account set -s $AZURE_SUBSCRIPTION_ID

printf "Building and uploading otel-collector image to $ACR_NAME. Please wait..."
az acr build --resource-group $GROUP_NAME \
  --registry $ACR_NAME \
  --image my-otel-collector:latest \
  --file images/otel-collector/Dockerfile \
  --platform linux \
  --output none \
  images/otel-collector
printf "Success!\n"
