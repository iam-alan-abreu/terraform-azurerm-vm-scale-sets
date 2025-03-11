module "ssh_key_pair" {
  count                  = var.os_flavor == "linux" ? 1 : 0
  source                 = "./modules/tls-ssh-key-pair"
  create_ssh             = var.create_ssh
  kv_name                = var.kv_name
  kv_resource_group_name = var.kv_resource_group_name
  name_key               = var.name_key
  ssh_public_key_path    = "./secrets"
  private_key_extension  = ".pem"
  public_key_extension   = ".pub"
  chmod_command          = "chmod 600 %v"
}

module "win_password" {
  count                  = (var.os_flavor == "windows" && var.admin_password == null) ? 1 : 0
  source                 = "./modules/random-password"
  kv_name                = var.kv_name
  kv_resource_group_name = var.kv_resource_group_name
  name_key               = var.name_key
  length                 = 16
  special                = true
  override_special       = "!#$%&*()-_=+[]{}<>:?"
}
