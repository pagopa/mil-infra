##!/bin/sh
set -x
. 00_create_dev_init.sh

# Container App.
mongoConnectionString1=$(az cosmosdb keys list --name $cosmosName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[0].connectionString' --output tsv)
mongoConnectionString2=$(az cosmosdb keys list --name $cosmosName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[1].connectionString' --output tsv)
az containerapp create \
  --name $caName \
  --resource-group $resourceGroup \
  --environment $caeName \
  --ingress external \
  --exposed-port 80 \
  --target-port 8080 \
  --transport http \
  --image "ghcr.io/pagopa/mil-functions:1.0.4" \
  --secrets "mongo-connection-string-1=$mongoConnectionString1" \
            "mongo-connection-string-2=$mongoConnectionString2" \
  --env-vars "quarkus-log-level=ERROR" \
             "app-log-level=DEBUG" \
             "mongo-connect-timeout=5s" \
             "mongo-read-timeout=10s" \
             "mongo-server-selecion-timeout=5s" \
             "mongo-connection-string-1=secretref:mongo-connection-string-1" \
             "mongo-connection-string-2=secretref:mongo-connection-string-2"
