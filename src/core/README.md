<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 1.3.9 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.39.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.53.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.39.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.53.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acquirer_conf_api"></a> [acquirer\_conf\_api](#module\_acquirer\_conf\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management | v6.20.0 |
| <a name="module_auth_api"></a> [auth\_api](#module\_auth\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_cae"></a> [cae](#module\_cae) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment | v6.20.0 |
| <a name="module_fee_calculator_api"></a> [fee\_calculator\_api](#module\_fee\_calculator\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_github_runner"></a> [github\_runner](#module\_github\_runner) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment | v6.20.0 |
| <a name="module_idpay_api"></a> [idpay\_api](#module\_idpay\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault | v6.20.0 |
| <a name="module_mil_product"></a> [mil\_product](#module\_mil\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.20.0 |
| <a name="module_mock_nodo"></a> [mock\_nodo](#module\_mock\_nodo) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.20.0 |
| <a name="module_mock_nodo_api"></a> [mock\_nodo\_api](#module\_mock\_nodo\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_payment_notice_api"></a> [payment\_notice\_api](#module\_payment\_notice\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_preset_api"></a> [preset\_api](#module\_preset\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.20.0 |
| <a name="module_redis_cache"></a> [redis\_cache](#module\_redis\_cache) | git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache | v6.20.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_diagnostic.acquirer_conf_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.auth_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.fee_calculator_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.idpay_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.payment_notice_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.preset_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_subscription.tracing](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/api_management_subscription) | resource |
| [azurerm_application_insights.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/application_insights) | resource |
| [azurerm_cosmosdb_account.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.idpayTransactions](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.paymentTransactions](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.presets](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.subscribers](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_caa_record.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_ns_record.dev_mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.uat_mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/dns_zone) | resource |
| [azurerm_eventhub.presets](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.mil_evhns](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/eventhub_namespace) | resource |
| [azurerm_log_analytics_query_pack.query_pack](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack) | resource |
| [azurerm_log_analytics_query_pack_query.failed_requestes](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_auth_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_errors_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_fee_calculator_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_idpay_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_payment_notice_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_preset_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.cosmos_pep](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.eventhub_pep](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.storage_pep](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.app](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.github_runner](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.integration](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group_template_deployment.mil_auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_storage_account.conf](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_account) | resource |
| [azurerm_storage_account.mock](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.stub_gec](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ko_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ok](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.acquirers](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.clients](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.mock](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.roles](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.users](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/subnet) | resource |
| [azurerm_subnet.app](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/subnet) | resource |
| [azurerm_subnet.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/subnet) | resource |
| [azurerm_subnet.data](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/subnet) | resource |
| [azurerm_subnet.github_runner](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/resources/virtual_network) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.39.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.39.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.39.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.39.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.gec_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.idpay_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.mil_acquirer_conf_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_rest_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_soap_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.53.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | The name of the publisher. | `string` | `"PagoPA S.p.A."` | no |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | String made up of two components separated by an underscore: the 1st component is the name (Consumption, Developer, Basic, Standard, Premium); the 2nd component is the capacity (it must be an integer greater than 0). | `string` | n/a | yes |
| <a name="input_apim_snet_cidr"></a> [apim\_snet\_cidr](#input\_apim\_snet\_cidr) | API Manager Subnet CIDR. | `string` | n/a | yes |
| <a name="input_app_gateway"></a> [app\_gateway](#input\_app\_gateway) | Application Gateway configuration | <pre>object({<br>    min_capacity = number<br>    max_capacity = number<br>    waf_enabled  = bool<br>    sku_name     = string<br>    sku_tier     = string<br>  })</pre> | n/a | yes |
| <a name="input_app_snet_cidr"></a> [app\_snet\_cidr](#input\_app\_snet\_cidr) | Application Subnet CIDR. | `string` | n/a | yes |
| <a name="input_appgw_snet_cidr"></a> [appgw\_snet\_cidr](#input\_appgw\_snet\_cidr) | App GW Subnet CIDR. | `string` | n/a | yes |
| <a name="input_data_snet_cidr"></a> [data\_snet\_cidr](#input\_data\_snet\_cidr) | Data Subnet CIDR. | `string` | n/a | yes |
| <a name="input_dns_default_ttl"></a> [dns\_default\_ttl](#input\_dns\_default\_ttl) | Time-to-live (seconds). | `number` | `3600` | no |
| <a name="input_dns_external_domain"></a> [dns\_external\_domain](#input\_dns\_external\_domain) | Organization external domain. | `string` | `"pagopa.it"` | no |
| <a name="input_dns_zone_mil_prefix"></a> [dns\_zone\_mil\_prefix](#input\_dns\_zone\_mil\_prefix) | Product DNS zone name prefix. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_github_runner_cidr"></a> [github\_runner\_cidr](#input\_github\_runner\_cidr) | GitHub runner Subnet CIDR. | `string` | n/a | yes |
| <a name="input_integr_vnet_cidr"></a> [integr\_vnet\_cidr](#input\_integr\_vnet\_cidr) | Integration Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_intern_vnet_cidr"></a> [intern\_vnet\_cidr](#input\_intern\_vnet\_cidr) | Internal Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Log Analytics Workspace variables | <pre>object({<br>    sku               = string<br>    retention_in_days = number<br>    daily_quota_gb    = number<br>  })</pre> | <pre>{<br>  "daily_quota_gb": 1,<br>  "retention_in_days": 30,<br>  "sku": "PerGB2018"<br>}</pre> | no |
| <a name="input_mil_acquirer_conf_connect_timeout"></a> [mil\_acquirer\_conf\_connect\_timeout](#input\_mil\_acquirer\_conf\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_acquirer_conf_openapi_descriptor"></a> [mil\_acquirer\_conf\_openapi\_descriptor](#input\_mil\_acquirer\_conf\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_acquirer_conf_read_timeout"></a> [mil\_acquirer\_conf\_read\_timeout](#input\_mil\_acquirer\_conf\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_acquirer_conf_url"></a> [mil\_acquirer\_conf\_url](#input\_mil\_acquirer\_conf\_url) | mil-payment-notice and mil-fee-calculator specific | `string` | n/a | yes |
| <a name="input_mil_acquirer_conf_ver"></a> [mil\_acquirer\_conf\_ver](#input\_mil\_acquirer\_conf\_ver) | n/a | `string` | `"1.0.0"` | no |
| <a name="input_mil_auth_access_duration"></a> [mil\_auth\_access\_duration](#input\_mil\_auth\_access\_duration) | n/a | `number` | `900` | no |
| <a name="input_mil_auth_app_log_level"></a> [mil\_auth\_app\_log\_level](#input\_mil\_auth\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_auth_cpu"></a> [mil\_auth\_cpu](#input\_mil\_auth\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_auth_cryptoperiod"></a> [mil\_auth\_cryptoperiod](#input\_mil\_auth\_cryptoperiod) | n/a | `number` | `86400000` | no |
| <a name="input_mil_auth_ephemeral_storage"></a> [mil\_auth\_ephemeral\_storage](#input\_mil\_auth\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_auth_image"></a> [mil\_auth\_image](#input\_mil\_auth\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_auth_json_logging"></a> [mil\_auth\_json\_logging](#input\_mil\_auth\_json\_logging) | n/a | `bool` | `false` | no |
| <a name="input_mil_auth_keysize"></a> [mil\_auth\_keysize](#input\_mil\_auth\_keysize) | n/a | `number` | `4096` | no |
| <a name="input_mil_auth_max_replicas"></a> [mil\_auth\_max\_replicas](#input\_mil\_auth\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_auth_memory"></a> [mil\_auth\_memory](#input\_mil\_auth\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_auth_min_replicas"></a> [mil\_auth\_min\_replicas](#input\_mil\_auth\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_auth_openapi_descriptor"></a> [mil\_auth\_openapi\_descriptor](#input\_mil\_auth\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_auth_quarkus_log_level"></a> [mil\_auth\_quarkus\_log\_level](#input\_mil\_auth\_quarkus\_log\_level) | mil-auth specific | `string` | `"ERROR"` | no |
| <a name="input_mil_auth_redis_db"></a> [mil\_auth\_redis\_db](#input\_mil\_auth\_redis\_db) | n/a | `string` | `"9"` | no |
| <a name="input_mil_auth_refresh_duration"></a> [mil\_auth\_refresh\_duration](#input\_mil\_auth\_refresh\_duration) | n/a | `number` | `3600` | no |
| <a name="input_mil_fee_calculator_app_log_level"></a> [mil\_fee\_calculator\_app\_log\_level](#input\_mil\_fee\_calculator\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_fee_calculator_cpu"></a> [mil\_fee\_calculator\_cpu](#input\_mil\_fee\_calculator\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_fee_calculator_ephemeral_storage"></a> [mil\_fee\_calculator\_ephemeral\_storage](#input\_mil\_fee\_calculator\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_fee_calculator_gec_connect_timeout"></a> [mil\_fee\_calculator\_gec\_connect\_timeout](#input\_mil\_fee\_calculator\_gec\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_gec_read_timeout"></a> [mil\_fee\_calculator\_gec\_read\_timeout](#input\_mil\_fee\_calculator\_gec\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_gec_url"></a> [mil\_fee\_calculator\_gec\_url](#input\_mil\_fee\_calculator\_gec\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_fee_calculator_image"></a> [mil\_fee\_calculator\_image](#input\_mil\_fee\_calculator\_image) | mil-fee-calculator specific | `string` | n/a | yes |
| <a name="input_mil_fee_calculator_jwt_publickey_location"></a> [mil\_fee\_calculator\_jwt\_publickey\_location](#input\_mil\_fee\_calculator\_jwt\_publickey\_location) | n/a | `string` | `null` | no |
| <a name="input_mil_fee_calculator_max_replicas"></a> [mil\_fee\_calculator\_max\_replicas](#input\_mil\_fee\_calculator\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_fee_calculator_memory"></a> [mil\_fee\_calculator\_memory](#input\_mil\_fee\_calculator\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_fee_calculator_min_replicas"></a> [mil\_fee\_calculator\_min\_replicas](#input\_mil\_fee\_calculator\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_fee_calculator_openapi_descriptor"></a> [mil\_fee\_calculator\_openapi\_descriptor](#input\_mil\_fee\_calculator\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_fee_calculator_quarkus_log_level"></a> [mil\_fee\_calculator\_quarkus\_log\_level](#input\_mil\_fee\_calculator\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mil_idpay_app_log_level"></a> [mil\_idpay\_app\_log\_level](#input\_mil\_idpay\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_idpay_cpu"></a> [mil\_idpay\_cpu](#input\_mil\_idpay\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_idpay_ephemeral_storage"></a> [mil\_idpay\_ephemeral\_storage](#input\_mil\_idpay\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_idpay_idpay_rest_api_url"></a> [mil\_idpay\_idpay\_rest\_api\_url](#input\_mil\_idpay\_idpay\_rest\_api\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_idpay_image"></a> [mil\_idpay\_image](#input\_mil\_idpay\_image) | mil-idpay specific | `string` | n/a | yes |
| <a name="input_mil_idpay_jwt_publickey_location"></a> [mil\_idpay\_jwt\_publickey\_location](#input\_mil\_idpay\_jwt\_publickey\_location) | n/a | `string` | `null` | no |
| <a name="input_mil_idpay_location_base_url"></a> [mil\_idpay\_location\_base\_url](#input\_mil\_idpay\_location\_base\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_idpay_max_replicas"></a> [mil\_idpay\_max\_replicas](#input\_mil\_idpay\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_idpay_memory"></a> [mil\_idpay\_memory](#input\_mil\_idpay\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_idpay_min_replicas"></a> [mil\_idpay\_min\_replicas](#input\_mil\_idpay\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_idpay_mongo_connect_timeout"></a> [mil\_idpay\_mongo\_connect\_timeout](#input\_mil\_idpay\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_idpay_mongo_read_timeout"></a> [mil\_idpay\_mongo\_read\_timeout](#input\_mil\_idpay\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_idpay_mongo_server_selection_timeout"></a> [mil\_idpay\_mongo\_server\_selection\_timeout](#input\_mil\_idpay\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_idpay_openapi_descriptor"></a> [mil\_idpay\_openapi\_descriptor](#input\_mil\_idpay\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_idpay_quarkus_log_level"></a> [mil\_idpay\_quarkus\_log\_level](#input\_mil\_idpay\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mil_idpay_transaction_max_retry"></a> [mil\_idpay\_transaction\_max\_retry](#input\_mil\_idpay\_transaction\_max\_retry) | n/a | `number` | `3` | no |
| <a name="input_mil_idpay_transaction_retry_after"></a> [mil\_idpay\_transaction\_retry\_after](#input\_mil\_idpay\_transaction\_retry\_after) | n/a | `number` | `30` | no |
| <a name="input_mil_payment_notice_activatepayment_expiration_time"></a> [mil\_payment\_notice\_activatepayment\_expiration\_time](#input\_mil\_payment\_notice\_activatepayment\_expiration\_time) | n/a | `number` | `30000` | no |
| <a name="input_mil_payment_notice_app_log_level"></a> [mil\_payment\_notice\_app\_log\_level](#input\_mil\_payment\_notice\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_payment_notice_close_payment_max_retry"></a> [mil\_payment\_notice\_close\_payment\_max\_retry](#input\_mil\_payment\_notice\_close\_payment\_max\_retry) | n/a | `number` | `3` | no |
| <a name="input_mil_payment_notice_closepayment_location_base_url"></a> [mil\_payment\_notice\_closepayment\_location\_base\_url](#input\_mil\_payment\_notice\_closepayment\_location\_base\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_payment_notice_closepayment_retry_after"></a> [mil\_payment\_notice\_closepayment\_retry\_after](#input\_mil\_payment\_notice\_closepayment\_retry\_after) | n/a | `number` | `30` | no |
| <a name="input_mil_payment_notice_cpu"></a> [mil\_payment\_notice\_cpu](#input\_mil\_payment\_notice\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_payment_notice_ephemeral_storage"></a> [mil\_payment\_notice\_ephemeral\_storage](#input\_mil\_payment\_notice\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_payment_notice_image"></a> [mil\_payment\_notice\_image](#input\_mil\_payment\_notice\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_payment_notice_jwt_publickey_location"></a> [mil\_payment\_notice\_jwt\_publickey\_location](#input\_mil\_payment\_notice\_jwt\_publickey\_location) | n/a | `string` | `null` | no |
| <a name="input_mil_payment_notice_max_replicas"></a> [mil\_payment\_notice\_max\_replicas](#input\_mil\_payment\_notice\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_payment_notice_memory"></a> [mil\_payment\_notice\_memory](#input\_mil\_payment\_notice\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_payment_notice_min_replicas"></a> [mil\_payment\_notice\_min\_replicas](#input\_mil\_payment\_notice\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_payment_notice_mongo_connect_timeout"></a> [mil\_payment\_notice\_mongo\_connect\_timeout](#input\_mil\_payment\_notice\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_payment_notice_mongo_read_timeout"></a> [mil\_payment\_notice\_mongo\_read\_timeout](#input\_mil\_payment\_notice\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_payment_notice_mongo_server_selection_timeout"></a> [mil\_payment\_notice\_mongo\_server\_selection\_timeout](#input\_mil\_payment\_notice\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_payment_notice_node_rest_service_url"></a> [mil\_payment\_notice\_node\_rest\_service\_url](#input\_mil\_payment\_notice\_node\_rest\_service\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_payment_notice_node_soap_client_connect_timeout"></a> [mil\_payment\_notice\_node\_soap\_client\_connect\_timeout](#input\_mil\_payment\_notice\_node\_soap\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_node_soap_client_read_timeout"></a> [mil\_payment\_notice\_node\_soap\_client\_read\_timeout](#input\_mil\_payment\_notice\_node\_soap\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_node_soap_service_url"></a> [mil\_payment\_notice\_node\_soap\_service\_url](#input\_mil\_payment\_notice\_node\_soap\_service\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_payment_notice_openapi_descriptor"></a> [mil\_payment\_notice\_openapi\_descriptor](#input\_mil\_payment\_notice\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_payment_notice_quarkus_log_level"></a> [mil\_payment\_notice\_quarkus\_log\_level](#input\_mil\_payment\_notice\_quarkus\_log\_level) | mil-payment-notice specific | `string` | `"ERROR"` | no |
| <a name="input_mil_payment_notice_rest_client_connect_timeout"></a> [mil\_payment\_notice\_rest\_client\_connect\_timeout](#input\_mil\_payment\_notice\_rest\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_rest_client_read_timeout"></a> [mil\_payment\_notice\_rest\_client\_read\_timeout](#input\_mil\_payment\_notice\_rest\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_preset_app_log_level"></a> [mil\_preset\_app\_log\_level](#input\_mil\_preset\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_preset_cpu"></a> [mil\_preset\_cpu](#input\_mil\_preset\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_preset_ephemeral_storage"></a> [mil\_preset\_ephemeral\_storage](#input\_mil\_preset\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_preset_image"></a> [mil\_preset\_image](#input\_mil\_preset\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_preset_jwt_publickey_location"></a> [mil\_preset\_jwt\_publickey\_location](#input\_mil\_preset\_jwt\_publickey\_location) | n/a | `string` | `null` | no |
| <a name="input_mil_preset_location_base_url"></a> [mil\_preset\_location\_base\_url](#input\_mil\_preset\_location\_base\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_preset_max_replicas"></a> [mil\_preset\_max\_replicas](#input\_mil\_preset\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_preset_memory"></a> [mil\_preset\_memory](#input\_mil\_preset\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_preset_min_replicas"></a> [mil\_preset\_min\_replicas](#input\_mil\_preset\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_preset_mongo_connect_timeout"></a> [mil\_preset\_mongo\_connect\_timeout](#input\_mil\_preset\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_preset_mongo_read_timeout"></a> [mil\_preset\_mongo\_read\_timeout](#input\_mil\_preset\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_preset_mongo_server_selection_timeout"></a> [mil\_preset\_mongo\_server\_selection\_timeout](#input\_mil\_preset\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_preset_openapi_descriptor"></a> [mil\_preset\_openapi\_descriptor](#input\_mil\_preset\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_preset_quarkus_log_level"></a> [mil\_preset\_quarkus\_log\_level](#input\_mil\_preset\_quarkus\_log\_level) | mil-preset specific | `string` | `"ERROR"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | General variables definition | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
