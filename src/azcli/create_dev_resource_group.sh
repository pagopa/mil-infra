#!/bin/sh
set -x
. create_dev_init.sh

az group create \
  --name $resourceGroup \
  --location westeurope \
  --subscription DEV-mil
