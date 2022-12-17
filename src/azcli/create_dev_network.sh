##!/bin/sh
set -x
. create_dev_init.sh

# Virtual Network + App Gateway Subnet.
az network vnet create \
  --name $vnetName \
  --resource-group $resourceGroup \
  --location westeurope \
  --address-prefix $vnetAddressPrefix \
  --subnet-name $agwSubnetName \
  --subnet-prefix $agwSubnetAddressPrefix

# API Manager Subnet.
az network vnet subnet create \
  --name $apimSubnetName \
  --resource-group $resourceGroup \
  --vnet-name $vnetName \
  --address-prefix $apimSubnetAddressPrefix

# Container Apps Environment Subnet.
az network vnet subnet create \
  --name $caeSubnetName \
  --resource-group $resourceGroup \
  --vnet-name $vnetName \
  --address-prefix $caeSubnetAddressPrefix

# Cosmos Subnet.
az network vnet subnet create \
  --name $cosmosSubnetName \
  --resource-group $resourceGroup \
  --vnet-name $vnetName \
  --address-prefix $cosmosSubnetAddressPrefix
