#
# Azure AD
#
data "azuread_group" "adgroup_admin" {
  display_name = "${local.project}-adgroup-admin"
}

data "azuread_group" "adgroup_developers" {
  display_name = "${local.project}-adgroup-developers"
}

data "azuread_group" "adgroup_externals" {
  display_name = "${local.project}-adgroup-externals"
}

data "azuread_group" "adgroup_security" {
  display_name = "${local.project}-adgroup-security"
}

resource "azuread_application" "mil_services" {
  display_name = "${local.project}-services"

  required_resource_access {
    # Microsoft Graph
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      # User.Read
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  required_resource_access {
    # Azure Key Vault
    resource_app_id = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

    resource_access {
      # user_impersonation
      id   = "f53da476-18e3-4152-8e01-aec403e6edc0"
      type = "Scope"
    }
  }


  device_only_auth_enabled       = false
  fallback_public_client_enabled = false
  group_membership_claims        = []
  identifier_uris                = []
  oauth2_post_response_required  = false
  owners                         = []
  prevent_duplicate_names        = false
  sign_in_audience               = "AzureADMyOrg"

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 1
  }

  feature_tags {
    custom_single_sign_on = false
    enterprise            = false
    gallery               = false
    hide                  = false
  }

  public_client {
    redirect_uris = []
  }

  single_page_application {
    redirect_uris = []
  }

  web {
    redirect_uris = []

    implicit_grant {
      access_token_issuance_enabled = false
      id_token_issuance_enabled     = false
    }
  }
}

resource "azuread_service_principal" "mil_services" {
  application_id = azuread_application.mil_services.application_id
  use_existing   = true
}

resource "azuread_application_password" "mil_services" {
  application_object_id = azuread_application.mil_services.object_id
  display_name          = "${local.project}-services"
  end_date_relative     = "262800h"
}