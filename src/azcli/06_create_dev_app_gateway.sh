##!/bin/sh
set -x
. 00_create_dev_init.sh

# Public IP.
az network public-ip create \
  --name $publicIpName \
  --resource-group $resourceGroup \
  --allocation-method Static \
  --sku Standard

# Application Gateway.
apimFqdn=$(az apim show --name $apimName --resource-group $resourceGroup --query 'gatewayUrl' --output tsv | sed 's/https:\/\///')
az network application-gateway create \
  --name $agwName \
  --location westeurope \
  --resource-group $resourceGroup \
  --capacity 2 \
  --sku Standard_v2 \
  --public-ip-address $publicIpName \
  --vnet-name $vnetName \
  --subnet $agwSubnetName \
  --http-settings-protocol https \
  --http-settings-port 443 \
  --servers $apimFqdn \
  --priority 100