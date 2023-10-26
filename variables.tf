variable "my_virtual_machine_password" {
  default     = "PASSWORD"
  description = "Password of the Virtual Machine"
}

variable "my_virtual_machine_size" {
  default     = "Standard_B2s"
  description = "Size of the Virtual Machine"
}

variable "location" {

  default     = "westus"
  description = "Location of the resource group."
}


variable "name" {

  default     = "trovalds"
  description = "Name of the resource."
}


variable "nameresourcegroup" {

  default     = "labs-linux"
  description = "Name of RG"
}


