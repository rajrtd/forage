# ===========
# VNet & Subnets: Student Exercise (Fill in below)
# ===========

# TODO: Learners write azurerm_virtual_network "vnet" and TWO azurerm_subnet resources:
# - One for the virtual network (e.g., "demo-vnet", "192.168.0.0/16")
# - One for the public subnet (e.g., "public-subnet", "192.168.0.0/18")
# - One for the private subnet (e.g., "private-subnet", "192.168.128.0/18")
#
# Example skeletons to fill:
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Public Subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/18"]
}

# Private Subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.128.0/18"]
}

# 1. When the name and address prefixes have been entered, highlight lines 10-29 and press Ctrl + / to uncomment.
# 2. Press Ctrl + S to save the file.
