terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14.0" 
    }
  }
}


provider "azurerm" {
    features {}
    subscription_id = "8ad5cd5f-b3a7-48ba-a0d8-968da7f89e2e"
}

