##!/bin/sh
set -x
. 00_create_dev_init.sh

# API Manager.
az apim create \
  --name $apimName \
  --resource-group $resourceGroup \
  --location westeurope \
  --publisher-email "antonio.tarricone@pagopa.it" \
  --publisher-name "PagoPA" \
  --virtual-network External \
  --sku-name Developer

# Add Back-end Subnet reference to API Manager.
apimSubnetResourceId=$(az network vnet subnet show --name $apimSubnetName --resource-group $resourceGroup --vnet-name $vnetName --query 'id' --output tsv)
apimResourceId=$(az apim show --name $apimName --resource-group $resourceGroup --query 'id' --output tsv)
az resource update \
  --ids $apimResourceId \
  --set properties.virtualNetworkConfiguration.subnetResourceId=$apimSubnetResourceId \
  --set properties.virtualNetworkType="External"
