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
# resource "azurerm_virtual_network" "vnet" {
#   name                = "ENTER_YOUR_VNET_NAME_HERE"
#   address_space       = ["ENTER_YOUR_VNET_ADDRESS_SPACE_HERE"]
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# # Public Subnet
# resource "azurerm_subnet" "public_subnet" {
#   name                 = "ENTER_YOUR_PUBLIC_SUBNET_NAME_HERE"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["ENTER_YOUR_PUBLIC_SUBNET_ADDRESS_PREFIX_HERE"]
# }

# # Private Subnet
# resource "azurerm_subnet" "private_subnet" {
#   name                 = "ENTER_YOUR_PRIVATE_SUBNET_NAME_HERE"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["ENTER_YOUR_PRIVATE_SUBNET_ADDRESS_PREFIX_HERE"]
# }

# 1. When the name and address prefixes have been entered, highlight lines 10-29 and press Ctrl + / to uncomment.
# 2. Press Ctrl + S to save the file.
