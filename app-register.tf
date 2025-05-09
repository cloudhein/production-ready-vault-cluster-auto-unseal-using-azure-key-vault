########## register an app in mirosoft entra id ##########

resource "azuread_application" "az-kv-vault-unseal-app" {
  display_name = "az-kv-vault-unseal-app"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9" # Application.ReadWrite.All
      type = "Role"
    }

    resource_access {
      id   = "19dbc75e-c2e2-444c-a770-ec69d8559fc7" # Directory.ReadWrite.All
      type = "Role"
    }
  }
}

resource "azuread_application_password" "az-kv-vault-unseal-app-secret" {
  application_id = azuread_application.az-kv-vault-unseal-app.id
  display_name   = "Vault AZ KV Secret"
  #end_date_relative = "240h"
}