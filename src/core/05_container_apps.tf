# Log Analytics Workspace.
resource "azurerm_log_analytics_workspace" "cae_log" {
  name                = "${local.project}-cae-log"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = azurerm_resource_group.app_rg.location
  tags                = var.tags
}

# Container Apps Environment.
resource "azapi_resource" "cae" {
  name      = "${local.project}-cae"
  location  = azurerm_resource_group.app_rg.location
  parent_id = azurerm_resource_group.app_rg.id
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  tags      = var.tags

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.cae_log.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.cae_log.primary_shared_key
        }
      }
      vnetConfiguration = {
        infrastructureSubnetId = azurerm_subnet.app.id
        internal               = false
      }
    }
  })
}

# Container App.
resource "azapi_resource" "init_ca" {
  name      = "${local.project}-init-ca"
  location  = azurerm_resource_group.app_rg.location
  parent_id = azurerm_resource_group.app_rg.id
  type      = "Microsoft.App/containerapps@2022-03-01"
  tags      = var.tags

  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.cae.id
      configuration = {
        ingress = {
          external   = true
          targetPort = 8080
          transport  = "Http"
        }
        secrets = [
          {
            name  = "mongo-connection-string-1"
            value = azurerm_cosmosdb_account.mil.connection_strings[0]
          },
          {
            name  = "mongo-connection-string-2"
            value = azurerm_cosmosdb_account.mil.connection_strings[1]
          }
        ]
      }
      template = {
        containers = [
          {
            image = "ghcr.io/pagopa/mil-functions:1.0.4"
            name  = "mil-functions"
            resources = {
              cpu    = 0.25
              memory = "0.5Gi"
            }
            env = [
              {
                name  = "quarkus-log-level"
                value = "ERROR"
              },
              {
                name  = "app-log-level"
                value = "DEBUG"
              },
              {
                name  = "mongo-connect-timeout"
                value = "5s"
              },
              {
                name  = "mongo-read-timeout"
                value = "10s"
              },
              {
                name  = "mongo-server-selecion-timeout"
                value = "5s"
              },
              {
                name      = "mongo-connection-string-1"
                secretRef = "mongo-connection-string-1"
              },
              {
                name      = "mongo-connection-string-2"
                secretRef = "mongo-connection-string-2"
              }
            ]
          }
        ]
        scale = {
          minReplicas = 0
          maxReplicas = 10
        }
      }
    }
  })
}