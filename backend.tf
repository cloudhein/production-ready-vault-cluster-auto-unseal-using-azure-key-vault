terraform {
  cloud {

    organization = "az-kv-org"

    workspaces {
      name = "az-kv-vault-auto-unseal"
    }
  }
}