#!/bin/sh
set -x
. 00_create_dev_init.sh

az group create \
  --name $resourceGroup \
  --location westeurope \
  --subscription DEV-mil
