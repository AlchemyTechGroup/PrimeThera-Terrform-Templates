terraform {
  required_providers {
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "0.1.0"
    }
    
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
azuread = {
      source  = "hashicorp/azuread"
      version = "=2.11.0"
    }
  }
  backend "azurerm" {
  resource_group_name  = var.sa_resource_group
  storage_account_name = var.storage_account
  container_name       = var.container_name
  key                  = var.key
  subscription_id      = var.sub_id_dev
  tenant_id            = var.tenant_id
  }
}
provider "azurerm" {
  features {}
}