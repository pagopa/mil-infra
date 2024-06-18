# ==============================================================================
# This file contains stuff needed to run mil-perf microservice.
# ==============================================================================

# ------------------------------------------------------------------------------
# Container app.
# ------------------------------------------------------------------------------
resource "azurerm_container_app" "perf" {
  count                        = var.env_short == "d" ? 1 : 0
  name                         = "${local.project}-perf-ca"
  container_app_environment_id = azurerm_container_app_environment.mil.id
  resource_group_name          = azurerm_resource_group.app.name
  revision_mode                = "Single"

  template {
    container {
      name   = "mil-perf"
      image  = "ghcr.io/pagopa/mil-perf@sha256:92a7694017ffea406c8706d808d8051c592c7a501a09a39b7f2a3a1eaf083de2"
      cpu    = 2
      memory = "4Gi"

      env {
        name  = "TZ"
        value = "Europe/Rome"
      }
    }

    max_replicas = 10
    min_replicas = 2
  }

  identity {
    type = "SystemAssigned"
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      latest_revision = true
      percentage      = 100
      #revision_suffix = formatdate("YYYYMMDDhhmmssZZZZ", timestamp())
    }
  }

  tags = var.tags
}
