terraform {
  required_version = ">=0.13"

  required_providers {
    #azapi = {
    #  source  = "azure/azapi"
    #  version = "~>1.5"
    #}
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.72.0"
    }
    #random = {
    #  source  = "hashicorp/random"
    #  version = "~>3.0"
    #}
  }
}


provider "azurerm" {
  features {}
}