variable "location" {
  type        = string
  description = "Azure location where the Key Vault resource to be created"
  default     = "southeastasia"
}

variable "environment" {
  type        = string
  description = "The environment where the Key Vault resource to be created"
  default     = "dev"
}

variable "service_principal" {
  type        = string
  description = "Service principal display name"
  default     = "terraform app"
}