<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.31.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.31.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cae"></a> [cae](#module\_cae) | git::https://github.com/pagopa/terraform-azurerm-v3.git//container_app_environment | v3.4.5 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault | v3.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_caa_record.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_ns_record.dev_mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.uat_mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.mil](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_log_analytics_workspace.cae_log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.app_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.dmz_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.integration_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group_template_deployment.init_ca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_subnet.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.dmz](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_snet_cidr"></a> [apim\_snet\_cidr](#input\_apim\_snet\_cidr) | API Manager Subnet CIDR. | `string` | n/a | yes |
| <a name="input_app_snet_cidr"></a> [app\_snet\_cidr](#input\_app\_snet\_cidr) | Application Subnet CIDR. | `string` | n/a | yes |
| <a name="input_data_snet_cidr"></a> [data\_snet\_cidr](#input\_data\_snet\_cidr) | Data Subnet CIDR. | `string` | n/a | yes |
| <a name="input_dmz_snet_cidr"></a> [dmz\_snet\_cidr](#input\_dmz\_snet\_cidr) | DMZ Subnet CIDR. | `string` | n/a | yes |
| <a name="input_dns_default_ttl"></a> [dns\_default\_ttl](#input\_dns\_default\_ttl) | Time-to-live (seconds). | `number` | `3600` | no |
| <a name="input_dns_external_domain"></a> [dns\_external\_domain](#input\_dns\_external\_domain) | Organization external domain. | `string` | `"pagopa.it"` | no |
| <a name="input_dns_zone_mil_prefix"></a> [dns\_zone\_mil\_prefix](#input\_dns\_zone\_mil\_prefix) | Product DNS zone name prefix. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_integr_vnet_cidr"></a> [integr\_vnet\_cidr](#input\_integr\_vnet\_cidr) | Integration Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_intern_vnet_cidr"></a> [intern\_vnet\_cidr](#input\_intern\_vnet\_cidr) | Internal Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
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
| <a name="input_prefix"></a> [prefix](#input\_prefix) | General variables definition. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_init_ca_application_url"></a> [init\_ca\_application\_url](#output\_init\_ca\_application\_url) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
