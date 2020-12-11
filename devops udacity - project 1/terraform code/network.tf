resource "azurerm_virtual_network" "mynetwork" {

    name = "${var.prefix}-vnet"
    resource_group_name = azurerm_resource_group.resourcegroup.name
    location = var.yourlocation
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mysubnet1" {

    name = "${var.prefix}-subnet1"
    resource_group_name = azurerm_resource_group.resourcegroup.name
    virtual_network_name = azurerm_virtual_network.mynetwork.name
    address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pubip" {

    name = "LoadbalancerpublicIp"
    location = var.yourlocation
    resource_group_name = azurerm_resource_group.resourcegroup.name
    allocation_method = "Static"
}

resource "azurerm_lb" "loadbalancer" {

    name = "loadBalancer"
    location = var.yourlocation
    resource_group_name = azurerm_resource_group.resourcegroup.name

    frontend_ip_configuration {
        name = "publicIpAdress"
        public_ip_address_id = azurerm_public_ip.pubip.id
    }
}

resource "azurerm_lb_backend_address_pool" "lbbackend" {

    resource_group_name = azurerm_resource_group.resourcegroup.name
    loadbalancer_id = azurerm_lb.loadbalancer.id
    name = "BackendAddressPool"
}

resource "azurerm_network_interface" "niccard" {

    count =  var.numberofvm
    name = "nic-card-${count.index}"
    location = var.yourlocation
    resource_group_name = azurerm_resource_group.resourcegroup.name

    ip_configuration {
        name = "ipconfig"
        subnet_id = azurerm_subnet.mysubnet1.id
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_network_security_group" "nsg" {

    name = "networksecuritygroup"
    location = var.yourlocation
    resource_group_name = azurerm_resource_group.resourcegroup.name

    security_rule {
    name                       = "allowprivatevm"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "10.0.0.0/24"
  }

    security_rule {
    name                       = "alldeny"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "10.0.0.0/24"
  }

  tags = {
    device = "nsg"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsginsubnet" {
  subnet_id                 = azurerm_subnet.mysubnet1.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
