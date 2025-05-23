terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.64.0"
    }
  }
}

provider "tfe" {
  # Configuration options
  token = var.hcp_token
}