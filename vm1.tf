resource "azurerm_public_ip" "my-public-ip" {
  name                    = "Public-ip-${var.name}"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}



resource "azurerm_network_interface" "mynetworkinterface" {
  name                = "network-interface-${var.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-${var.name}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my-public-ip.id



  }
}



# Windows 11 Virtual Machine
resource "azurerm_linux_virtual_machine" "myvmlinuxvm1" {
  name                = "vm-${var.name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.my_virtual_machine_size
  custom_data         = base64encode(file("web.sh"))
  network_interface_ids = [
    azurerm_network_interface.mynetworkinterface.id,
  ]




  computer_name                   = "vm-${var.name}"
  admin_username                  = "chicano"
  admin_password                  = var.my_virtual_machine_password
  disable_password_authentication = false


  os_disk {
    name                 = "vmdisk-${var.name}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }



  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


  #  provisioner "remote-exec" {
  #    inline = [
  #      "sudo apt update -y",
  #      "sudo apt install -y apache2",
  #      "sudo apt install -y git",
  #      "sudo mkdir -p /var/www/app",
  #      "sudo git -C /var/www/app/ clone https://Ch1c4n0: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@github.com/Ch1c4n0/public_html.git",
  #      "sudo mv /var/www/app/public_html /var/www/public_html",
  #      "sudo sed -i 's/html/public_html/' /etc/apache2/sites-available/000-default.conf",
  #      "sudo a2ensite 000-default.conf",
  #      "sudo systemctl restart apache2"
  #
  #    ]
  #
  #    connection {
  #      type     = "ssh"
  #      host     = azurerm_linux_virtual_machine.myvmlinuxvm1.public_ip_address
  #      user     = azurerm_linux_virtual_machine.myvmlinuxvm1.admin_username
  #      password = var.my_virtual_machine_password
  #    }
  #

}

# provisioner "local-exec" {
#   #working_dir = "/home"
#   command = "echo '<h1>Azure Linux VM with Web Server 2- Terraform </h1>' > /var/www/html/teste/teste.html"
#   
# }


#}

# Security Group - allowing RDP Connection
resource "azurerm_network_security_group" "sg-vm1" {
  name                = "allowrdpconnection-${var.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "webport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = {
    environment = "Testing"
  }
}


# Associate security group with network interface
resource "azurerm_network_interface_security_group_association" "my_association" {
  network_interface_id      = azurerm_network_interface.mynetworkinterface.id
  network_security_group_id = azurerm_network_security_group.sg-vm1.id
}
