##!/bin/sh
set -x
. create_dev_init.sh

az extension add --name containerapp --upgrade
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights

# Log Analytics Workspace.
az monitor log-analytics workspace create \
  --workspace-name $logAnalyticsWorkspaceName \
  --resource-group $resourceGroup

# Container Apps Environment.
caeSubnetResourceId=$(az network vnet subnet show --name $caeSubnetName --resource-group $resourceGroup --vnet-name $vnetName --query 'id' --output tsv)
logsWorkspaceId=$(az monitor log-analytics workspace show --workspace-name $logAnalyticsWorkspaceName --resource-group $resourceGroup --query 'customerId' --output tsv)
az containerapp env create \
  --name $caeName \
  --resource-group $resourceGroup \
  --location westeurope \
  --infrastructure-subnet-resource-id $caeSubnetResourceId \
  --logs-workspace-id $logsWorkspaceId

# Container App.
mongoConnectionString1=$(az cosmosdb keys list --name $cosmosName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[0].connectionString' --output tsv)
mongoConnectionString2=$(az cosmosdb keys list --name $cosmosName --resource-group $resourceGroup --type connection-strings --query 'connectionStrings[1].connectionString' --output tsv)
az containerapp create \
  --name mil-d-weu-init-ca \
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
