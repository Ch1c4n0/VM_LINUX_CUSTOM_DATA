output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "ip_internal" {

  value = azurerm_network_interface.mynetworkinterface.private_ip_address

}


output "web_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       = azurerm_linux_virtual_machine.myvmlinuxvm1.public_ip_address
}