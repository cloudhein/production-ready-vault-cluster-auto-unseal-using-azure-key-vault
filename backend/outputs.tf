output "organization_id" {
  value       = tfe_organization.my-hcp-organization.id
  description = "Your Organization ID"
  sensitive   = false
}

output "project_id" {
  value       = tfe_project.my-hcp-project.name
  description = "Your Project ID"
  sensitive   = false
}

output "workspace_id" {
  value       = tfe_workspace.my-hcp-workspace.name
  description = "Your Workspace ID"
  sensitive   = false
}