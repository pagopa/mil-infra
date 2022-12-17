##!/bin/sh
set -x
. create_dev_init.sh

# Cosmos Account for MondoDB API.
az cosmosdb create \
  --name $cosmosName \
  --resource-group $resourceGroup \
  --kind MongoDB \
  --server-version 4.2 \
  --default-consistency-level Eventual \
  --locations regionName=westeurope failoverPriority=0 isZoneRedundant=False \
  --capabilities EnableServerless

# MongoDB API Database.
az cosmosdb mongodb database create \
  --name mil \
  --account-name $cosmosName \
  --resource-group $resourceGroup

# MongoDB API Collection.
az cosmosdb mongodb collection create \
  --name services \
  --database-name mil \
  --account-name $cosmosName \
  --resource-group $resourceGroup \
  --idx "[{\"key\": {\"keys\": [\"channel\"]}, \"options\": {\"unique\": \"true\"}}]"
