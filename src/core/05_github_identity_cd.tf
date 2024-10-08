/**
This terraform file handle github identity federation with Azure, allowing
Github action to login with Azure CLI by using a managed identity.
*/
locals {
  repositories = [
    {
      repository : "mil-terminal-registry"
      subject : var.env
    },
    {
      repository : "mil-papos"
      subject : var.env
    },
    {
      repository : "mil-auth"
      subject : var.env
    },
    {
      repository : "mil-payment-notice"
      subject : var.env
    },
    {
      repository : "mil-fee-calculator"
      subject : var.env
    },
    {
      repository : "mil-idpay"
      subject : var.env
    },
    {
      repository : "mil-preset"
      subject : var.env
    },
    {
      repository : "mil-debt-position"
      subject : var.env
    }
  ]

  resource_groups_roles_cd = [
    {
      resource_group_id : azurerm_resource_group.sec.id,
      role : "Key Vault Reader"
    },
    {
      resource_group_id : azurerm_resource_group.app.id,
      role : "Contributor"
    }
  ]
}

resource "azurerm_user_assigned_identity" "identity_cd" {
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  location            = azurerm_resource_group.managed_identities_rg.location
  name                = "${var.prefix}-${var.env_short}-github-cd-identity"

  tags = var.tags
}

resource "azurerm_role_assignment" "identity_subscription_role_assignment_cd" {
  for_each             = toset(["Contributor"])
  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}

resource "azurerm_role_assignment" "identity_rg_role_assignment_cd" {
  count                = length(local.resource_groups_roles_cd)
  scope                = local.resource_groups_roles_cd[count.index].resource_group_id
  role_definition_name = local.resource_groups_roles_cd[count.index].role
  principal_id         = azurerm_user_assigned_identity.identity_cd.principal_id
}

resource "azurerm_federated_identity_credential" "identity_credentials_cd" {
  for_each            = { for g in local.repositories : "${g.repository}.environment.${g.subject}" => g } # key must be unique
  resource_group_name = azurerm_resource_group.managed_identities_rg.name
  name                = "${var.prefix}-${var.env_short}-${local.domain}-github-${each.value.repository}-environment-${each.value.subject}"
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.identity_cd.id
  subject             = "repo:pagopa/${each.value.repository}:environment:${each.value.subject}-cd"
}
