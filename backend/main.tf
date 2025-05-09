resource "tfe_organization" "my-hcp-organization" {
  name  = var.hcp_organization
  email = var.email_address
}

resource "tfe_project" "my-hcp-project" {
  organization = tfe_organization.my-hcp-organization.id
  name         = var.hcp_project
}

resource "tfe_workspace" "my-hcp-workspace" {
  name         = var.hcp_workspace
  organization = tfe_organization.my-hcp-organization.id
  project_id   = tfe_project.my-hcp-project.id
}

resource "tfe_variable" "az-subscription-id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = var.az_subscription_id
  category     = "env"
  description  = "Azure Subscription ID"
  workspace_id = tfe_workspace.my-hcp-workspace.id
  sensitive    = true
}

resource "tfe_variable" "az-client-id" {
  key          = "ARM_CLIENT_ID"
  value        = var.az_client_id
  category     = "env"
  description  = "Azure Client ID"
  workspace_id = tfe_workspace.my-hcp-workspace.id
  sensitive    = true
}

resource "tfe_variable" "az-tenant-id" {
  key          = "ARM_TENANT_ID"
  value        = var.az_tenant_id
  category     = "env"
  description  = "Azure Tenant ID"
  workspace_id = tfe_workspace.my-hcp-workspace.id
  sensitive    = true
}

resource "tfe_variable" "az-client-secret" {
  key          = "ARM_CLIENT_SECRET"
  value        = var.az_client_secret
  category     = "env"
  description  = "Azure Client Secret"
  workspace_id = tfe_workspace.my-hcp-workspace.id
  sensitive    = true
}
