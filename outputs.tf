output "vault-autounseal-app-client-secret" {
  description = "vault autounseal app credentials(client secret)"
  value       = azuread_application_password.az-kv-vault-unseal-app-secret.value
  sensitive   = true
}

output "vault-autounseal-app-client-id" {
  description = "vault autounseal app client id"
  value       = azuread_application.az-kv-vault-unseal-app.client_id
  sensitive   = true
}

output "my-account-tenant-id" {
  description = "tenant id"
  value       = data.azurerm_client_config.current.tenant_id
  sensitive   = true
}

output "az-vault-name" {
  description = "vault name"
  value       = azurerm_key_vault.key-vault.name
  sensitive   = false
}

output "az-vault-key-name" {
  description = "vault key name"
  value       = azurerm_key_vault_key.generated.name
  sensitive   = false
}