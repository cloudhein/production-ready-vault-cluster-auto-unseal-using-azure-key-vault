variable "hcp_token" {
  description = "value of the hcp token"
  type        = string
  sensitive   = true
}

variable "hcp_organization" {
  description = "value of your hcp organization"
  type        = string
}

variable "email_address" {
  description = "value of your email address"
  type        = string
}

variable "hcp_project" {
  description = "value of your hcp project"
  type        = string
}

variable "hcp_workspace" {
  description = "value of your hcp workspace"
  type        = string
}

variable "az_subscription_id" {
  description = "value of the az subscription id"
  type        = string
}

variable "az_client_id" {
  description = "Azure Client ID"
  type        = string
  sensitive   = true
}

variable "az_client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "az_tenant_id" {
  description = "value of the az tenant id"
  type        = string
  sensitive   = true
}