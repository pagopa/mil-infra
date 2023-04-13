<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.31.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.44.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.31.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.44.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acquirer_conf_api"></a> [acquirer\_conf\_api](#module\_acquirer\_conf\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_acquirer_conf_api__internal"></a> [acquirer\_conf\_api\_\_internal](#module\_acquirer\_conf\_api\_\_internal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management | v5.1.0 |
| <a name="module_app_gw"></a> [app\_gw](#module\_app\_gw) | git::https://github.com/pagopa/terraform-azurerm-v3.git//app_gateway | v5.1.0 |
| <a name="module_cae"></a> [cae](#module\_cae) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment | v5.1.0 |
| <a name="module_fee_calculator_api"></a> [fee\_calculator\_api](#module\_fee\_calculator\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_fee_calculator_api__external__api_key"></a> [fee\_calculator\_api\_\_external\_\_api\_key](#module\_fee\_calculator\_api\_\_external\_\_api\_key) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_fee_calculator_api__external__oauth"></a> [fee\_calculator\_api\_\_external\_\_oauth](#module\_fee\_calculator\_api\_\_external\_\_oauth) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_functions_api"></a> [functions\_api](#module\_functions\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_github_runner"></a> [github\_runner](#module\_github\_runner) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment | v5.1.0 |
| <a name="module_idp_api"></a> [idp\_api](#module\_idp\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault | v5.1.0 |
| <a name="module_mil_product"></a> [mil\_product](#module\_mil\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v5.1.0 |
| <a name="module_mil_product__external__api_key"></a> [mil\_product\_\_external\_\_api\_key](#module\_mil\_product\_\_external\_\_api\_key) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v5.1.0 |
| <a name="module_mil_product__external__oauth"></a> [mil\_product\_\_external\_\_oauth](#module\_mil\_product\_\_external\_\_oauth) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v5.1.0 |
| <a name="module_mil_product__internal"></a> [mil\_product\_\_internal](#module\_mil\_product\_\_internal) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v5.1.0 |
| <a name="module_mock_nodo"></a> [mock\_nodo](#module\_mock\_nodo) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v5.1.0 |
| <a name="module_mock_nodo_api"></a> [mock\_nodo\_api](#module\_mock\_nodo\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_payment_notice_api"></a> [payment\_notice\_api](#module\_payment\_notice\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_payment_notice_api__external__api_key"></a> [payment\_notice\_api\_\_external\_\_api\_key](#module\_payment\_notice\_api\_\_external\_\_api\_key) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_payment_notice_api__external__oauth"></a> [payment\_notice\_api\_\_external\_\_oauth](#module\_payment\_notice\_api\_\_external\_\_oauth) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v5.1.0 |
| <a name="module_redis_cache"></a> [redis\_cache](#module\_redis\_cache) | git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache | v5.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_diagnostic.acquirer_conf_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.acquirer_conf_api__internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.fee_calculator_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.fee_calculator_api__external__api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.fee_calculator_api__external__oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.functions_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.idp_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.payment_notice_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.payment_notice_api__external__api_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.payment_notice_api__external__oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_subscription.tracing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_subscription) | resource |
| [azurerm_application_insights.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_cosmosdb_account.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.pspconf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_a_record.api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_caa_record.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_ns_record.dev_mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.uat_mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_log_analytics_query_pack.query_pack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack) | resource |
| [azurerm_log_analytics_query_pack_query.failed_requestes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_fee_calculator_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_functions_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_payment_notice_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.cosmos_pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.github_runner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group_template_deployment.mil_fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_functions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_idp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.mil_payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_role_assignment.apim_id__to__conf_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.appgw_id_api-dev-mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.conf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.mock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.acquirer_4585625](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.acquirer_4585626](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_gec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ko_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ok](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.acquirer_conf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.mock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.github_runner](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_certificate.api-dev-mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.gec_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.mil_acquirer_conf_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_rest_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_soap_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

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
| <a name="input_mil_acquirer_conf_read_timeout"></a> [mil\_acquirer\_conf\_read\_timeout](#input\_mil\_acquirer\_conf\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_acquirer_conf_url"></a> [mil\_acquirer\_conf\_url](#input\_mil\_acquirer\_conf\_url) | mil-payment-notice and mil-fee-calculator specific. | `string` | `null` | no |
| <a name="input_mil_acquirer_conf_ver"></a> [mil\_acquirer\_conf\_ver](#input\_mil\_acquirer\_conf\_ver) | n/a | `string` | `"1.0.0"` | no |
| <a name="input_mil_fee_calculator_app_log_level"></a> [mil\_fee\_calculator\_app\_log\_level](#input\_mil\_fee\_calculator\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_fee_calculator_cpu"></a> [mil\_fee\_calculator\_cpu](#input\_mil\_fee\_calculator\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_fee_calculator_ephemeral_storage"></a> [mil\_fee\_calculator\_ephemeral\_storage](#input\_mil\_fee\_calculator\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_fee_calculator_gec_connect_timeout"></a> [mil\_fee\_calculator\_gec\_connect\_timeout](#input\_mil\_fee\_calculator\_gec\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_gec_read_timeout"></a> [mil\_fee\_calculator\_gec\_read\_timeout](#input\_mil\_fee\_calculator\_gec\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_gec_url"></a> [mil\_fee\_calculator\_gec\_url](#input\_mil\_fee\_calculator\_gec\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_fee_calculator_image"></a> [mil\_fee\_calculator\_image](#input\_mil\_fee\_calculator\_image) | mil-fee-calculator specific. | `string` | `"ghcr.io/pagopa/mil-fee-calculator:latest"` | no |
| <a name="input_mil_fee_calculator_max_replicas"></a> [mil\_fee\_calculator\_max\_replicas](#input\_mil\_fee\_calculator\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_fee_calculator_memory"></a> [mil\_fee\_calculator\_memory](#input\_mil\_fee\_calculator\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_fee_calculator_min_replicas"></a> [mil\_fee\_calculator\_min\_replicas](#input\_mil\_fee\_calculator\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_fee_calculator_quarkus_log_level"></a> [mil\_fee\_calculator\_quarkus\_log\_level](#input\_mil\_fee\_calculator\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mil_functions_app_log_level"></a> [mil\_functions\_app\_log\_level](#input\_mil\_functions\_app\_log\_level) | Log level for application. | `string` | `"DEBUG"` | no |
| <a name="input_mil_functions_cpu"></a> [mil\_functions\_cpu](#input\_mil\_functions\_cpu) | CPUs assigned to the container. | `number` | `0.5` | no |
| <a name="input_mil_functions_ephemeral_storage"></a> [mil\_functions\_ephemeral\_storage](#input\_mil\_functions\_ephemeral\_storage) | Ephemeral storage assigned to the container. | `string` | `"1.0Gi"` | no |
| <a name="input_mil_functions_image"></a> [mil\_functions\_image](#input\_mil\_functions\_image) | Image of mil-functions microservice. | `string` | `"ghcr.io/pagopa/mil-functions:latest"` | no |
| <a name="input_mil_functions_max_replicas"></a> [mil\_functions\_max\_replicas](#input\_mil\_functions\_max\_replicas) | Max number of replicas. | `number` | `5` | no |
| <a name="input_mil_functions_memory"></a> [mil\_functions\_memory](#input\_mil\_functions\_memory) | Memory assigned to the container. | `string` | `"1.0Gi"` | no |
| <a name="input_mil_functions_min_replicas"></a> [mil\_functions\_min\_replicas](#input\_mil\_functions\_min\_replicas) | Min number of replicas. | `number` | `0` | no |
| <a name="input_mil_functions_mongo_connect_timeout"></a> [mil\_functions\_mongo\_connect\_timeout](#input\_mil\_functions\_mongo\_connect\_timeout) | Mongo connect timeout. | `string` | `"5s"` | no |
| <a name="input_mil_functions_mongo_read_timeout"></a> [mil\_functions\_mongo\_read\_timeout](#input\_mil\_functions\_mongo\_read\_timeout) | Mongo read timeout. | `string` | `"10s"` | no |
| <a name="input_mil_functions_mongo_server_selection_timeout"></a> [mil\_functions\_mongo\_server\_selection\_timeout](#input\_mil\_functions\_mongo\_server\_selection\_timeout) | Mongo server selection timeout. | `string` | `"5s"` | no |
| <a name="input_mil_functions_quarkus_log_level"></a> [mil\_functions\_quarkus\_log\_level](#input\_mil\_functions\_quarkus\_log\_level) | Log level for Quarkus platform. | `string` | `"ERROR"` | no |
| <a name="input_mil_idp_access_audience"></a> [mil\_idp\_access\_audience](#input\_mil\_idp\_access\_audience) | n/a | `string` | `"https://mil-d-apim.azure-api.net/mil-payment-notice,https://mil-d-apim.azure-api.net/mil-fee-calculator"` | no |
| <a name="input_mil_idp_access_duration"></a> [mil\_idp\_access\_duration](#input\_mil\_idp\_access\_duration) | n/a | `number` | `300` | no |
| <a name="input_mil_idp_app_log_level"></a> [mil\_idp\_app\_log\_level](#input\_mil\_idp\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_idp_cpu"></a> [mil\_idp\_cpu](#input\_mil\_idp\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_idp_cryptoperiod"></a> [mil\_idp\_cryptoperiod](#input\_mil\_idp\_cryptoperiod) | n/a | `number` | `86400000` | no |
| <a name="input_mil_idp_ephemeral_storage"></a> [mil\_idp\_ephemeral\_storage](#input\_mil\_idp\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_idp_image"></a> [mil\_idp\_image](#input\_mil\_idp\_image) | n/a | `string` | `"ghcr.io/pagopa/mil-idp:latest"` | no |
| <a name="input_mil_idp_issuer"></a> [mil\_idp\_issuer](#input\_mil\_idp\_issuer) | n/a | `string` | `"https://mil-d-apim.azure-api.net/mil-idp"` | no |
| <a name="input_mil_idp_keysize"></a> [mil\_idp\_keysize](#input\_mil\_idp\_keysize) | n/a | `number` | `4096` | no |
| <a name="input_mil_idp_max_replicas"></a> [mil\_idp\_max\_replicas](#input\_mil\_idp\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mil_idp_memory"></a> [mil\_idp\_memory](#input\_mil\_idp\_memory) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_idp_min_replicas"></a> [mil\_idp\_min\_replicas](#input\_mil\_idp\_min\_replicas) | n/a | `number` | `0` | no |
| <a name="input_mil_idp_quarkus_log_level"></a> [mil\_idp\_quarkus\_log\_level](#input\_mil\_idp\_quarkus\_log\_level) | mil-idp | `string` | `"ERROR"` | no |
| <a name="input_mil_idp_refresh_audience"></a> [mil\_idp\_refresh\_audience](#input\_mil\_idp\_refresh\_audience) | n/a | `string` | `"https://mil-d-apim.azure-api.net/mil-idp"` | no |
| <a name="input_mil_idp_refresh_duration"></a> [mil\_idp\_refresh\_duration](#input\_mil\_idp\_refresh\_duration) | n/a | `number` | `3600` | no |
| <a name="input_mil_payment_notice_activatepayment_expiration_time"></a> [mil\_payment\_notice\_activatepayment\_expiration\_time](#input\_mil\_payment\_notice\_activatepayment\_expiration\_time) | n/a | `number` | `30000` | no |
| <a name="input_mil_payment_notice_app_log_level"></a> [mil\_payment\_notice\_app\_log\_level](#input\_mil\_payment\_notice\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_payment_notice_close_payment_max_retry"></a> [mil\_payment\_notice\_close\_payment\_max\_retry](#input\_mil\_payment\_notice\_close\_payment\_max\_retry) | n/a | `number` | `3` | no |
| <a name="input_mil_payment_notice_closepayment_location_base_url"></a> [mil\_payment\_notice\_closepayment\_location\_base\_url](#input\_mil\_payment\_notice\_closepayment\_location\_base\_url) | n/a | `string` | `null` | no |
| <a name="input_mil_payment_notice_closepayment_retry_after"></a> [mil\_payment\_notice\_closepayment\_retry\_after](#input\_mil\_payment\_notice\_closepayment\_retry\_after) | n/a | `number` | `30` | no |
| <a name="input_mil_payment_notice_cpu"></a> [mil\_payment\_notice\_cpu](#input\_mil\_payment\_notice\_cpu) | n/a | `number` | `0.5` | no |
| <a name="input_mil_payment_notice_ephemeral_storage"></a> [mil\_payment\_notice\_ephemeral\_storage](#input\_mil\_payment\_notice\_ephemeral\_storage) | n/a | `string` | `"1.0Gi"` | no |
| <a name="input_mil_payment_notice_image"></a> [mil\_payment\_notice\_image](#input\_mil\_payment\_notice\_image) | n/a | `string` | `"ghcr.io/pagopa/mil-payment-notice:latest"` | no |
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
| <a name="input_mil_payment_notice_quarkus_log_level"></a> [mil\_payment\_notice\_quarkus\_log\_level](#input\_mil\_payment\_notice\_quarkus\_log\_level) | mil-payment-notice specific. | `string` | `"ERROR"` | no |
| <a name="input_mil_payment_notice_rest_client_connect_timeout"></a> [mil\_payment\_notice\_rest\_client\_connect\_timeout](#input\_mil\_payment\_notice\_rest\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_rest_client_read_timeout"></a> [mil\_payment\_notice\_rest\_client\_read\_timeout](#input\_mil\_payment\_notice\_rest\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | General variables definition. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
