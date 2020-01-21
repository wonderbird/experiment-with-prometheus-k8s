provider "azurerm" {
    version = "~>1.38.0"
}

resource "azurerm_resource_group" "k8s_resources" {
    name     = "k8srg"
    location = "westeurope"
}
