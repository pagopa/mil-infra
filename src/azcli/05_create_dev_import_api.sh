##!/bin/sh
set -x
. 00_create_dev_init.sh

# Import API in the API Manager (w/o subscription and version-set).
serviceFqdn=$(az containerapp show --name mil-d-weu-init-ca --resource-group mil-d-weu-rg --query 'properties.configuration.ingress.fqdn' --output tsv)
az apim api import \
  --path services \
  --resource-group $resourceGroup \
  --service-name $apimName \
  --specification-format OpenApi \
  --api-id services \
  --api-revision "1-0-4" \
  --api-type http \
  --description "Handling of service list for Multi-channel Integration Layer of SW Client Project." \
  --display-name "Functions" \
  --protocols https \
  --service-url "https://$serviceFqdn" \
  --specification-path "/Users/antonio.tarricone/eclipse-workspace/mil-apis/openapi/azure/functions.yaml" \
  --subscription-required false
