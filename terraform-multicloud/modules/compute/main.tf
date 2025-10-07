resource "aws_instance" "nginx_vm" {
  count = var.enable_aws ? 1 : 0
  ami           = "ami-0e306788ff2473ccb"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  user_data = file("${path.module}/../../docker/setup.sh")
  tags = { Name = "nginx-aws" }
}

resource "azurerm_linux_virtual_machine" "nginx_vm" {
  count = var.enable_azure ? 1 : 0
  name                = "nginx-vm-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [var.nic_id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}
