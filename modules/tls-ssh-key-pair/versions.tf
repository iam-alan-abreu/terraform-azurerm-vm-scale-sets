terraform {
  required_version = ">= 0.13.0"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11, < 4.0"
    }
  }
}
