##Resource group

# comment - CTRL K C

# uncomment - CTRL K U
resource "azurerm_resource_group" "azure_rg" {
  name     =  var.rgname
  location =  var.location
}

##Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name                 = var.vnet_name
    address_space        = var.address_space
    resource_group_name = azurerm_resource_group.azure_rg.name
    location             = azurerm_resource_group.azure_rg.location
}
/* ##Subnet for virtual machine */
resource "azurerm_subnet" "vmsubnet" {
  name                  =  var.subnet_name
  address_prefix        =  var.address_prefix
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.azure_rg.name

}

# ##Add a Public IP address
resource "azurerm_public_ip" "vmip" {
     count                  = 2
     name                   = "vm-ip-${count.index}"   # vm-ip-0     #vm-ip-1
     resource_group_name = azurerm_resource_group.azure_rg.name
     allocation_method      = "Static"
     location               = var.location
     
 } 

# # # ##Add a Network security group
resource "azurerm_network_security_group" "nsgname" {
     name                   = "vm-nsg"
     location               = azurerm_resource_group.azure_rg.location
     resource_group_name = azurerm_resource_group.azure_rg.name
    
    
     security_rule {
         name                       = "PORT_SSH"
         priority                   = 101
         direction                  = "Inbound"
         access                     = "Allow"
         protocol                   = "Tcp"
         source_port_range          = "*"
         destination_port_range     = "22"
         source_address_prefixes    = var.external_ip
         destination_address_prefix = "*"
   }
 }
# # ##Associate NSG with  subnet
 resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
     subnet_id                    = azurerm_subnet.vmsubnet.id 
     network_security_group_id    = azurerm_network_security_group.nsgname.id 
 }

# # # #NIC with Public IP Address
 /* resource "azurerm_network_interface" "terranic" {
     count                  = 2
     name                   = "vm-nic-${count.index}"
     location               = azurerm_resource_group.azure_rg.location
      resource_group_name = azurerm_resource_group.azure_rg.name
    
     ip_configuration {
         name                          = "external"
         subnet_id                     = azurerm_subnet.vmsubnet.id
         private_ip_address_allocation = "dynamic"
         public_ip_address_id          = element(azurerm_public_ip.vmip.*.id, count.index)
   }
 } */
  resource "azurerm_network_interface" "terranic" {
   count               = 2
   name                = "acctni${count.index}"
   location            = var.location
   resource_group_name = azurerm_resource_group.azure_rg.name

   ip_configuration {
     name                          = "testConfiguration"
     subnet_id                     = azurerm_subnet.vmsubnet.id
     private_ip_address_allocation = "Dynamic"
     public_ip_address_id          = element(azurerm_public_ip.vmip.*.id, count.index)
   }
 }
  resource "azurerm_managed_disk" "datadisk" {
   count                = 2
   name                 = "datadisk_existing_${count.index}"
   location               =  azurerm_resource_group.azure_rg.location
     resource_group_name = azurerm_resource_group.azure_rg.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "1023"
 }
  

# # ##Data Disk for Virtual Machine
#  resource "azurerm_virtual_machine" "terravm" {
#      name                  = "vm-stg-${count.index}"
#      location              = var.location
#      location               =  azurerm_resource_group.azure_rg.location
#      resource_group_name = azurerm_resource_group.azure_rg.name
#      count 		  = 2
#      network_interface_ids = element(azurerm_network_interface.terranic.*.id, count.index)
#      vm_size               = "Standard_B1ls"
#      delete_os_disk_on_termination = true
#      delete_data_disks_on_termination = true


#  storage_os_disk {
#      name                 = "osdisk-${count.index}"
#      caching              = "ReadWrite"
#      create_option        = "FromImage"
#      managed_disk_type    = "Premium_LRS"
#      disk_size_gb         = "30"
#    }

#   storage_data_disk {
#     name              = element(azurerm_managed_disk.datadisk.*.name, count.index)
#     managed_disk_id   = element(azurerm_managed_disk.datadisk.*.id, count.index)
#     create_option     = "Attach"
#     lun               = 1
#     disk_size_gb      = element(azurerm_managed_disk.datadisk.*.disk_size_gb, count.index)
#   }

#     storage_image_reference {
#      publisher       = "Canonical"
#      offer           = "UbuntuServer"
#      sku             = "16.04-LTS"
#      version         = "latest"
#    }
#    os_profile {
#          computer_name = "hostname"
#          admin_username = "techies"
#      }

#      os_profile_linux_config {
#        disable_password_authentication = true
       
#          ssh_keys {
#          path     = "/home/techies/.ssh/authorized_keys"
#          key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt1Pp6K2zEiK2+9X672/Yx0rFaoVprB2Khs5VowAM1HEVg3axcwXZwEeIsZISyLx/vAOkUDrv8cD6J+1EUwEGWaiKuCC7xjcpwFH2EiMoTUGGrgNGBfUWQNMbClTLcGI7lP0bcJMcKuzcKPLaISTxSyuIiKot+9SHSmSuxj+gNpP01Y0aPzcMWZVfbJ/N6B+zPsM+cpvwh rrabab-external-2020-03-03"
#        }
#      }
  
#     connection {
#          host = azurerm_public_ip.admingwip.id
#          user = "techies"
#          type = "ssh"
#          private_key = "${file("./id_rsa")}"
#          timeout = "1m"
#          agent = true
#    }
#  }


