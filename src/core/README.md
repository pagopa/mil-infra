<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.46.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.46.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.82.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management) | resource |
| [azurerm_api_management_api.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.mock_idpay_ipzs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.mock_nodo](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.terminal_registry](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_operation_policy.mock_gec](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.mock_nodo_rest](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.mock_nodo_soap](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_diagnostic.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_diagnostic) | resource |
| [azurerm_api_management_logger.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_logger) | resource |
| [azurerm_api_management_product.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_api.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.mock_idpay_ipzs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.mock_nodo](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.terminal_registry](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_subscription.tracing](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/api_management_subscription) | resource |
| [azurerm_application_insights.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/application_insights) | resource |
| [azurerm_container_app.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.mock_idpay_ipzs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.preset](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app.terminal_registry](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app) | resource |
| [azurerm_container_app_environment.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_app_environment) | resource |
| [azurerm_container_group.vpn_dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/container_group) | resource |
| [azurerm_cosmosdb_account.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.idpayLocalTransactions](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.idpayTransactions](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.initiatives](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.paymentTransactions](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.presets](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.subscribers](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.terminal_registry](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_cosmosdb_mongo_database.mock_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_caa_record.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_ns_record.dev_mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.uat_mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/dns_zone) | resource |
| [azurerm_eventhub.presets](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/eventhub_namespace) | resource |
| [azurerm_federated_identity_credential.identity_credentials_cd](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault.general](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/key_vault) | resource |
| [azurerm_log_analytics_query_pack.query_pack](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack) | resource |
| [azurerm_log_analytics_query_pack_query.auth_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.failed_requestes](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.fee_calculator_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_errors_container_app_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_idpay_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_preset_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.mil_terminal_registry_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_query_pack_query.payment_notice_ca_console_logs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.auth_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.auth_storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.conf_storage_pep](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.idpay_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/public_ip) | resource |
| [azurerm_redis_cache.mil](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.app](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.integration](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.managed_identities_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.auth_kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.auth_kv_to_read_certificates](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.auth_kv_to_read_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.auth_storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.conf_storage_for_fee_calculator](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.conf_storage_for_payment_notice](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.identity_rg_role_assignment_cd](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.identity_subscription_role_assignment_cd](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.idpay_kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.idpay_kv_to_read_certificates](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.idpay_kv_to_read_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.auth](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_account) | resource |
| [azurerm_storage_account.conf](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_account) | resource |
| [azurerm_storage_account.mock](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.stub_gec](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ko_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ko](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.stub_verify_ok_activate_ok](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.mock](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/subnet) | resource |
| [azurerm_subnet.app](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/subnet) | resource |
| [azurerm_subnet.appgw](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/subnet) | resource |
| [azurerm_subnet.dns_forwarder_snet](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/subnet) | resource |
| [azurerm_subnet.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.identity_cd](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_gateway.vpn](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/resources/virtual_network_gateway) | resource |
| [random_string.dns](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_application.vpn_app](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/application) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.46.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.client_id_mock_nodo](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.client_secret_mock_nodo](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.gec_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.idpay_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.idpay_subscription_key_for_ipzs](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_rest_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.node_soap_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.82.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | The name of the publisher. | `string` | `"PagoPA S.p.A."` | no |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | String made up of two components separated by an underscore: the 1st component is the name (Consumption, Developer, Basic, Standard, Premium); the 2nd component is the capacity (it must be an integer greater than 0). | `string` | n/a | yes |
| <a name="input_apim_snet_cidr"></a> [apim\_snet\_cidr](#input\_apim\_snet\_cidr) | API Manager Subnet CIDR. | `string` | n/a | yes |
| <a name="input_app_snet_cidr"></a> [app\_snet\_cidr](#input\_app\_snet\_cidr) | Application Subnet CIDR. | `string` | n/a | yes |
| <a name="input_appgw_snet_cidr"></a> [appgw\_snet\_cidr](#input\_appgw\_snet\_cidr) | App GW Subnet CIDR. | `string` | n/a | yes |
| <a name="input_dns_default_ttl"></a> [dns\_default\_ttl](#input\_dns\_default\_ttl) | Time-to-live (seconds). | `number` | `3600` | no |
| <a name="input_dns_external_domain"></a> [dns\_external\_domain](#input\_dns\_external\_domain) | Organization external domain. | `string` | `"pagopa.it"` | no |
| <a name="input_dns_zone_mil_prefix"></a> [dns\_zone\_mil\_prefix](#input\_dns\_zone\_mil\_prefix) | Product DNS zone name prefix. | `string` | n/a | yes |
| <a name="input_dnsforwarder_snet_cidr"></a> [dnsforwarder\_snet\_cidr](#input\_dnsforwarder\_snet\_cidr) | DNS Forwarder Subnet CIDR. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_gec_url"></a> [gec\_url](#input\_gec\_url) | URL of the real GEC. | `string` | n/a | yes |
| <a name="input_install_idpay_mock"></a> [install\_idpay\_mock](#input\_install\_idpay\_mock) | If true the mock of the IDPay and IPZS will be installed. | `bool` | `false` | no |
| <a name="input_install_ipzs_mock"></a> [install\_ipzs\_mock](#input\_install\_ipzs\_mock) | If true the mock of the IDPay and IPZS will be installed. | `bool` | `false` | no |
| <a name="input_install_nodo_mock"></a> [install\_nodo\_mock](#input\_install\_nodo\_mock) | If true the mock of the Nodo and GEC will be installed. | `bool` | `false` | no |
| <a name="input_integr_vnet_cidr"></a> [integr\_vnet\_cidr](#input\_integr\_vnet\_cidr) | Integration Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_intern_vnet_cidr"></a> [intern\_vnet\_cidr](#input\_intern\_vnet\_cidr) | Internal Virtual Network CIDR. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Log Analytics Workspace variables | <pre>object({<br>    sku               = string<br>    retention_in_days = number<br>    daily_quota_gb    = number<br>  })</pre> | <pre>{<br>  "daily_quota_gb": 1,<br>  "retention_in_days": 30,<br>  "sku": "PerGB2018"<br>}</pre> | no |
| <a name="input_mil_auth_access_duration"></a> [mil\_auth\_access\_duration](#input\_mil\_auth\_access\_duration) | n/a | `number` | `900` | no |
| <a name="input_mil_auth_app_log_level"></a> [mil\_auth\_app\_log\_level](#input\_mil\_auth\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_auth_cpu"></a> [mil\_auth\_cpu](#input\_mil\_auth\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_auth_cryptoperiod"></a> [mil\_auth\_cryptoperiod](#input\_mil\_auth\_cryptoperiod) | n/a | `number` | `86400000` | no |
| <a name="input_mil_auth_image"></a> [mil\_auth\_image](#input\_mil\_auth\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_auth_keysize"></a> [mil\_auth\_keysize](#input\_mil\_auth\_keysize) | n/a | `number` | `4096` | no |
| <a name="input_mil_auth_max_replicas"></a> [mil\_auth\_max\_replicas](#input\_mil\_auth\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_auth_memory"></a> [mil\_auth\_memory](#input\_mil\_auth\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_auth_min_replicas"></a> [mil\_auth\_min\_replicas](#input\_mil\_auth\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_auth_openapi_descriptor"></a> [mil\_auth\_openapi\_descriptor](#input\_mil\_auth\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_auth_path"></a> [mil\_auth\_path](#input\_mil\_auth\_path) | n/a | `string` | `"mil-auth"` | no |
| <a name="input_mil_auth_quarkus_log_level"></a> [mil\_auth\_quarkus\_log\_level](#input\_mil\_auth\_quarkus\_log\_level) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | `"ERROR"` | no |
| <a name="input_mil_auth_quarkus_rest_client_logging_scope"></a> [mil\_auth\_quarkus\_rest\_client\_logging\_scope](#input\_mil\_auth\_quarkus\_rest\_client\_logging\_scope) | Scope for Quarkus REST client logging. Allowed values are: all, request-response, none. | `string` | `"all"` | no |
| <a name="input_mil_auth_refresh_duration"></a> [mil\_auth\_refresh\_duration](#input\_mil\_auth\_refresh\_duration) | n/a | `number` | `3600` | no |
| <a name="input_mil_fee_calculator_app_log_level"></a> [mil\_fee\_calculator\_app\_log\_level](#input\_mil\_fee\_calculator\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_fee_calculator_cpu"></a> [mil\_fee\_calculator\_cpu](#input\_mil\_fee\_calculator\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_fee_calculator_gec_connect_timeout"></a> [mil\_fee\_calculator\_gec\_connect\_timeout](#input\_mil\_fee\_calculator\_gec\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_gec_read_timeout"></a> [mil\_fee\_calculator\_gec\_read\_timeout](#input\_mil\_fee\_calculator\_gec\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_image"></a> [mil\_fee\_calculator\_image](#input\_mil\_fee\_calculator\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_fee_calculator_max_replicas"></a> [mil\_fee\_calculator\_max\_replicas](#input\_mil\_fee\_calculator\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_fee_calculator_memory"></a> [mil\_fee\_calculator\_memory](#input\_mil\_fee\_calculator\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_fee_calculator_min_replicas"></a> [mil\_fee\_calculator\_min\_replicas](#input\_mil\_fee\_calculator\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_fee_calculator_openapi_descriptor"></a> [mil\_fee\_calculator\_openapi\_descriptor](#input\_mil\_fee\_calculator\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_fee_calculator_path"></a> [mil\_fee\_calculator\_path](#input\_mil\_fee\_calculator\_path) | n/a | `string` | `"mil-fee-calculator"` | no |
| <a name="input_mil_fee_calculator_quarkus_log_level"></a> [mil\_fee\_calculator\_quarkus\_log\_level](#input\_mil\_fee\_calculator\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mil_fee_calculator_rest_client_connect_timeout"></a> [mil\_fee\_calculator\_rest\_client\_connect\_timeout](#input\_mil\_fee\_calculator\_rest\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_fee_calculator_rest_client_read_timeout"></a> [mil\_fee\_calculator\_rest\_client\_read\_timeout](#input\_mil\_fee\_calculator\_rest\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_idpay_app_log_level"></a> [mil\_idpay\_app\_log\_level](#input\_mil\_idpay\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_idpay_client_cert_name"></a> [mil\_idpay\_client\_cert\_name](#input\_mil\_idpay\_client\_cert\_name) | n/a | `string` | `"idpay"` | no |
| <a name="input_mil_idpay_cpu"></a> [mil\_idpay\_cpu](#input\_mil\_idpay\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_idpay_cryptoperiod"></a> [mil\_idpay\_cryptoperiod](#input\_mil\_idpay\_cryptoperiod) | n/a | `number` | `86400000` | no |
| <a name="input_mil_idpay_idpay_rest_api_url"></a> [mil\_idpay\_idpay\_rest\_api\_url](#input\_mil\_idpay\_idpay\_rest\_api\_url) | n/a | `string` | n/a | yes |
| <a name="input_mil_idpay_image"></a> [mil\_idpay\_image](#input\_mil\_idpay\_image) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_mil_idpay_ipzs_rest_api_url"></a> [mil\_idpay\_ipzs\_rest\_api\_url](#input\_mil\_idpay\_ipzs\_rest\_api\_url) | n/a | `string` | n/a | yes |
| <a name="input_mil_idpay_keysize"></a> [mil\_idpay\_keysize](#input\_mil\_idpay\_keysize) | n/a | `number` | `4096` | no |
| <a name="input_mil_idpay_max_replicas"></a> [mil\_idpay\_max\_replicas](#input\_mil\_idpay\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_idpay_memory"></a> [mil\_idpay\_memory](#input\_mil\_idpay\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_idpay_min_replicas"></a> [mil\_idpay\_min\_replicas](#input\_mil\_idpay\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_idpay_mongo_connect_timeout"></a> [mil\_idpay\_mongo\_connect\_timeout](#input\_mil\_idpay\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_idpay_mongo_read_timeout"></a> [mil\_idpay\_mongo\_read\_timeout](#input\_mil\_idpay\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_idpay_mongo_server_selection_timeout"></a> [mil\_idpay\_mongo\_server\_selection\_timeout](#input\_mil\_idpay\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_idpay_openapi_descriptor"></a> [mil\_idpay\_openapi\_descriptor](#input\_mil\_idpay\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_idpay_path"></a> [mil\_idpay\_path](#input\_mil\_idpay\_path) | n/a | `string` | `"mil-idpay"` | no |
| <a name="input_mil_idpay_quarkus_log_level"></a> [mil\_idpay\_quarkus\_log\_level](#input\_mil\_idpay\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mil_idpay_transaction_max_retry"></a> [mil\_idpay\_transaction\_max\_retry](#input\_mil\_idpay\_transaction\_max\_retry) | n/a | `number` | `10` | no |
| <a name="input_mil_idpay_transaction_retry_after"></a> [mil\_idpay\_transaction\_retry\_after](#input\_mil\_idpay\_transaction\_retry\_after) | n/a | `number` | `1` | no |
| <a name="input_mil_payment_notice_activatepayment_expiration_time"></a> [mil\_payment\_notice\_activatepayment\_expiration\_time](#input\_mil\_payment\_notice\_activatepayment\_expiration\_time) | n/a | `number` | `30000` | no |
| <a name="input_mil_payment_notice_app_log_level"></a> [mil\_payment\_notice\_app\_log\_level](#input\_mil\_payment\_notice\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_payment_notice_closepayment_max_retry"></a> [mil\_payment\_notice\_closepayment\_max\_retry](#input\_mil\_payment\_notice\_closepayment\_max\_retry) | n/a | `number` | `3` | no |
| <a name="input_mil_payment_notice_closepayment_retry_after"></a> [mil\_payment\_notice\_closepayment\_retry\_after](#input\_mil\_payment\_notice\_closepayment\_retry\_after) | n/a | `number` | `30` | no |
| <a name="input_mil_payment_notice_cpu"></a> [mil\_payment\_notice\_cpu](#input\_mil\_payment\_notice\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_payment_notice_image"></a> [mil\_payment\_notice\_image](#input\_mil\_payment\_notice\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_payment_notice_max_replicas"></a> [mil\_payment\_notice\_max\_replicas](#input\_mil\_payment\_notice\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_payment_notice_memory"></a> [mil\_payment\_notice\_memory](#input\_mil\_payment\_notice\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_payment_notice_min_replicas"></a> [mil\_payment\_notice\_min\_replicas](#input\_mil\_payment\_notice\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_payment_notice_mongo_connect_timeout"></a> [mil\_payment\_notice\_mongo\_connect\_timeout](#input\_mil\_payment\_notice\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_payment_notice_mongo_read_timeout"></a> [mil\_payment\_notice\_mongo\_read\_timeout](#input\_mil\_payment\_notice\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_payment_notice_mongo_server_selection_timeout"></a> [mil\_payment\_notice\_mongo\_server\_selection\_timeout](#input\_mil\_payment\_notice\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_payment_notice_node_soap_client_connect_timeout"></a> [mil\_payment\_notice\_node\_soap\_client\_connect\_timeout](#input\_mil\_payment\_notice\_node\_soap\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_node_soap_client_read_timeout"></a> [mil\_payment\_notice\_node\_soap\_client\_read\_timeout](#input\_mil\_payment\_notice\_node\_soap\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_openapi_descriptor"></a> [mil\_payment\_notice\_openapi\_descriptor](#input\_mil\_payment\_notice\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_payment_notice_path"></a> [mil\_payment\_notice\_path](#input\_mil\_payment\_notice\_path) | n/a | `string` | `"mil-payment-notice"` | no |
| <a name="input_mil_payment_notice_quarkus_log_level"></a> [mil\_payment\_notice\_quarkus\_log\_level](#input\_mil\_payment\_notice\_quarkus\_log\_level) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | `"ERROR"` | no |
| <a name="input_mil_payment_notice_rest_client_connect_timeout"></a> [mil\_payment\_notice\_rest\_client\_connect\_timeout](#input\_mil\_payment\_notice\_rest\_client\_connect\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_payment_notice_rest_client_read_timeout"></a> [mil\_payment\_notice\_rest\_client\_read\_timeout](#input\_mil\_payment\_notice\_rest\_client\_read\_timeout) | n/a | `number` | `2000` | no |
| <a name="input_mil_preset_app_log_level"></a> [mil\_preset\_app\_log\_level](#input\_mil\_preset\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_preset_cpu"></a> [mil\_preset\_cpu](#input\_mil\_preset\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_preset_image"></a> [mil\_preset\_image](#input\_mil\_preset\_image) | n/a | `string` | n/a | yes |
| <a name="input_mil_preset_max_replicas"></a> [mil\_preset\_max\_replicas](#input\_mil\_preset\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_preset_memory"></a> [mil\_preset\_memory](#input\_mil\_preset\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_preset_min_replicas"></a> [mil\_preset\_min\_replicas](#input\_mil\_preset\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_preset_mongo_connect_timeout"></a> [mil\_preset\_mongo\_connect\_timeout](#input\_mil\_preset\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_preset_mongo_read_timeout"></a> [mil\_preset\_mongo\_read\_timeout](#input\_mil\_preset\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_preset_mongo_server_selection_timeout"></a> [mil\_preset\_mongo\_server\_selection\_timeout](#input\_mil\_preset\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_preset_openapi_descriptor"></a> [mil\_preset\_openapi\_descriptor](#input\_mil\_preset\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_preset_path"></a> [mil\_preset\_path](#input\_mil\_preset\_path) | n/a | `string` | `"mil-preset"` | no |
| <a name="input_mil_preset_quarkus_log_level"></a> [mil\_preset\_quarkus\_log\_level](#input\_mil\_preset\_quarkus\_log\_level) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | `"ERROR"` | no |
| <a name="input_mil_terminal_registry_app_log_level"></a> [mil\_terminal\_registry\_app\_log\_level](#input\_mil\_terminal\_registry\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mil_terminal_registry_cpu"></a> [mil\_terminal\_registry\_cpu](#input\_mil\_terminal\_registry\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mil_terminal_registry_image"></a> [mil\_terminal\_registry\_image](#input\_mil\_terminal\_registry\_image) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_mil_terminal_registry_max_replicas"></a> [mil\_terminal\_registry\_max\_replicas](#input\_mil\_terminal\_registry\_max\_replicas) | n/a | `number` | `10` | no |
| <a name="input_mil_terminal_registry_memory"></a> [mil\_terminal\_registry\_memory](#input\_mil\_terminal\_registry\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mil_terminal_registry_min_replicas"></a> [mil\_terminal\_registry\_min\_replicas](#input\_mil\_terminal\_registry\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mil_terminal_registry_mongo_connect_timeout"></a> [mil\_terminal\_registry\_mongo\_connect\_timeout](#input\_mil\_terminal\_registry\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_terminal_registry_mongo_read_timeout"></a> [mil\_terminal\_registry\_mongo\_read\_timeout](#input\_mil\_terminal\_registry\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mil_terminal_registry_mongo_server_selection_timeout"></a> [mil\_terminal\_registry\_mongo\_server\_selection\_timeout](#input\_mil\_terminal\_registry\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mil_terminal_registry_openapi_descriptor"></a> [mil\_terminal\_registry\_openapi\_descriptor](#input\_mil\_terminal\_registry\_openapi\_descriptor) | n/a | `string` | n/a | yes |
| <a name="input_mil_terminal_registry_path"></a> [mil\_terminal\_registry\_path](#input\_mil\_terminal\_registry\_path) | n/a | `string` | `"mil-terminal-registry"` | no |
| <a name="input_mil_terminal_registry_quarkus_log_level"></a> [mil\_terminal\_registry\_quarkus\_log\_level](#input\_mil\_terminal\_registry\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mock_idpay_ipzs_app_log_level"></a> [mock\_idpay\_ipzs\_app\_log\_level](#input\_mock\_idpay\_ipzs\_app\_log\_level) | n/a | `string` | `"DEBUG"` | no |
| <a name="input_mock_idpay_ipzs_cpu"></a> [mock\_idpay\_ipzs\_cpu](#input\_mock\_idpay\_ipzs\_cpu) | n/a | `number` | `1` | no |
| <a name="input_mock_idpay_ipzs_image"></a> [mock\_idpay\_ipzs\_image](#input\_mock\_idpay\_ipzs\_image) | n/a | `string` | `"ghcr.io/pagopa/idpay-ipzs-mock:latest"` | no |
| <a name="input_mock_idpay_ipzs_max_replicas"></a> [mock\_idpay\_ipzs\_max\_replicas](#input\_mock\_idpay\_ipzs\_max\_replicas) | n/a | `number` | `5` | no |
| <a name="input_mock_idpay_ipzs_memory"></a> [mock\_idpay\_ipzs\_memory](#input\_mock\_idpay\_ipzs\_memory) | n/a | `string` | `"2Gi"` | no |
| <a name="input_mock_idpay_ipzs_min_replicas"></a> [mock\_idpay\_ipzs\_min\_replicas](#input\_mock\_idpay\_ipzs\_min\_replicas) | n/a | `number` | `1` | no |
| <a name="input_mock_idpay_ipzs_mongo_connect_timeout"></a> [mock\_idpay\_ipzs\_mongo\_connect\_timeout](#input\_mock\_idpay\_ipzs\_mongo\_connect\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mock_idpay_ipzs_mongo_read_timeout"></a> [mock\_idpay\_ipzs\_mongo\_read\_timeout](#input\_mock\_idpay\_ipzs\_mongo\_read\_timeout) | n/a | `string` | `"10s"` | no |
| <a name="input_mock_idpay_ipzs_mongo_server_selection_timeout"></a> [mock\_idpay\_ipzs\_mongo\_server\_selection\_timeout](#input\_mock\_idpay\_ipzs\_mongo\_server\_selection\_timeout) | n/a | `string` | `"5s"` | no |
| <a name="input_mock_idpay_ipzs_openapi_descriptor"></a> [mock\_idpay\_ipzs\_openapi\_descriptor](#input\_mock\_idpay\_ipzs\_openapi\_descriptor) | n/a | `string` | `"https://raw.githubusercontent.com/pagopa/idpay-ipzs-mock/main/src/main/resources/META-INF/openapi.yml"` | no |
| <a name="input_mock_idpay_ipzs_path"></a> [mock\_idpay\_ipzs\_path](#input\_mock\_idpay\_ipzs\_path) | n/a | `string` | `"idpay-ipzs-mock"` | no |
| <a name="input_mock_idpay_ipzs_quarkus_log_level"></a> [mock\_idpay\_ipzs\_quarkus\_log\_level](#input\_mock\_idpay\_ipzs\_quarkus\_log\_level) | n/a | `string` | `"ERROR"` | no |
| <a name="input_mock_idpay_rest_api_url"></a> [mock\_idpay\_rest\_api\_url](#input\_mock\_idpay\_rest\_api\_url) | n/a | `string` | n/a | yes |
| <a name="input_mock_ipzs_call_idpay_to_link_user_to_trx"></a> [mock\_ipzs\_call\_idpay\_to\_link\_user\_to\_trx](#input\_mock\_ipzs\_call\_idpay\_to\_link\_user\_to\_trx) | n/a | `string` | `"no"` | no |
| <a name="input_mock_nodo_path"></a> [mock\_nodo\_path](#input\_mock\_nodo\_path) | n/a | `string` | `"mockNodo"` | no |
| <a name="input_nodo_rest_url"></a> [nodo\_rest\_url](#input\_nodo\_rest\_url) | URL of the REST endpoint (close payment) of the real Nodo. | `string` | n/a | yes |
| <a name="input_nodo_soap_url"></a> [nodo\_soap\_url](#input\_nodo\_soap\_url) | URL of the SOAP endpoint (verify and activate operations) of the real Nodo. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | ------------------------------------------------------------------------------ Generic variables definition. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vpn_client_address_space"></a> [vpn\_client\_address\_space](#input\_vpn\_client\_address\_space) | n/a | `string` | n/a | yes |
| <a name="input_vpn_pip_sku"></a> [vpn\_pip\_sku](#input\_vpn\_pip\_sku) | n/a | `string` | n/a | yes |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | ------------------------------------------------------------------------------ Variables definition. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_vpn_snet_cidr"></a> [vpn\_snet\_cidr](#input\_vpn\_snet\_cidr) | VPN Subnet CIDR. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
