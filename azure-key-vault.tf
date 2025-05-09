# Create a resource group
resource "azurerm_resource_group" "vault-rg" {
  name     = "${var.environment}-vault-rg"
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "random_id" "keyvault" {
  byte_length = 4
}

# check your account tenant_id
data "azurerm_client_config" "current" {}

####### create az key vault ####### 
resource "azurerm_key_vault" "key-vault" {
  name                = "${var.environment}-vault-${random_id.keyvault.hex}"
  location            = azurerm_resource_group.vault-rg.location
  resource_group_name = azurerm_resource_group.vault-rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # Enable Azure RBAC for data plane (no more access policies)
  enable_rbac_authorization = true

  tags = {
    environment = var.environment
  }
}

# Retrieve the service principal object ID for the "terraform app"
data "azuread_service_principal" "terraform_app" {
  display_name = var.service_principal # Replace with the actual display name if different
}

# Assign "Key Vault Administrator" role to the <service principal> on the Key Vault
resource "azurerm_role_assignment" "keyvault_admin" {
  scope                = azurerm_key_vault.key-vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azuread_service_principal.terraform_app.object_id
}

# generate az key to autounseal the vault cluster
resource "azurerm_key_vault_key" "generated" {
  name         = "generated-key"
  key_vault_id = azurerm_key_vault.key-vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_role_assignment.keyvault_admin
  ]
}

# create a service principal for the az unseal app
resource "azuread_service_principal" "unseal_app_sp" {
  client_id = azuread_application.az-kv-vault-unseal-app.client_id
}


# Role assignment for Key Vault Secrets User to az unseal app
resource "azurerm_role_assignment" "secrets_user" {
  scope                = azurerm_key_vault.key-vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.unseal_app_sp.object_id # principal_id must be service principal
}

# Role assignment for Key Vault Crypto User to az unseal app
resource "azurerm_role_assignment" "crypto_user" {
  scope                = azurerm_key_vault.key-vault.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azuread_service_principal.unseal_app_sp.object_id # principal_id must be service principal
}