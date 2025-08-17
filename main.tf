resource "azurerm_resource_group" "rg" {
  name     = "demo-rg"
  location = "New Zealand North"
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = "demo-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicFrontEnd"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "this" {
  name            = "BackendPool"
  loadbalancer_id = azurerm_lb.lb.id
}

# Load Balancer Health Probe
resource "azurerm_lb_probe" "this" {
  name                = "tcp-probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# Load Balancer Rule
resource "azurerm_lb_rule" "http_rule" {
  name                           = "HTTPRule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  probe_id                       = azurerm_lb_probe.this.id
}

# Network Security Group (allowing HTTP inbound on public subnet)
resource "azurerm_network_security_group" "public_nsg" {
  name                = "public-subnet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "192.168.0.0/17"
    destination_address_prefix = "192.168.128.0/17"
  }
}

# Associate NSG to public subnet
resource "azurerm_subnet_network_security_group_association" "public_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

# Network Security Group for private subnet (restrict access)
resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-subnet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Example: allow all outbound, deny inbound for demonstration
  security_rule {
    name                       = "DenyInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "192.168.128.0/17"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                            = "demo-vmss"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  sku                             = "Standard_B1s"
  instances                       = 1
  zones                           = ["1"]
  disable_password_authentication = false
  admin_username                  = "adminuser"
  admin_password                  = var.vm_password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nicOne"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.private_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.this.id]
    }
  }

  custom_data = base64encode(file("custom_data_script.tpl"))
}

