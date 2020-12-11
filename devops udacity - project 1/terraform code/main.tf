terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.39.0"
    }
  }
}

provider "azurerm" {
  
  subscription_id = var.subid
  client_id = var.clientid
  client_secret = var.clientsecret
  tenant_id = var.tid

  features{}
}


resource "azurerm_resource_group" "resourcegroup" {

    name = "${var.prefix}-resourcegroup"
    location = var.yourlocation
}

data "azurerm_image" "ubuntu_image" {

    name = "Ubuntu1804-LTS"
    resource_group_name = "PackerImages"
}

resource "azurerm_managed_disk" "test" {
 count                = var.numberofvm
 name                 = "datadisk_existing_${count.index}"
 location             = var.yourlocation
 resource_group_name  = azurerm_resource_group.resourcegroup.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = var.yourlocation
 resource_group_name          = azurerm_resource_group.resourcegroup.name
 platform_fault_domain_count  = var.numberofvm
 platform_update_domain_count = var.numberofvm
 managed                      = true
}

resource "azurerm_virtual_machine" "linux_vm" {

    count = var.numberofvm
    name = "${var.prefix}-vm-${count.index}"
    resource_group_name = azurerm_resource_group.resourcegroup.name
    location = var.yourlocation
    network_interface_ids = [element(azurerm_network_interface.niccard.*.id, count.index)]
    vm_size = "Standard_DS1_v2"


    storage_image_reference{
        id = data.azurerm_image.ubuntu_image.id
    }

    storage_os_disk {
        
        name = "myosdisk-${count.index}"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_data_disk {
      name            = element(azurerm_managed_disk.test.*.name, count.index)
      managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
      create_option   = "Attach"
      lun             = 1
      disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
    }

    os_profile {

        computer_name = "linuxhost"
        admin_username = var.username
        admin_password = var.password
    }

    os_profile_linux_config {

        disable_password_authentication = false
    }

    tags = {
        device = "linuxvm"
    }
}

