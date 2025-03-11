data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "kv_ssh" {
  name                = var.kv_name
  resource_group_name = var.kv_resource_group_name
  depends_on          = [local_file.private_key_pem]
}

# Get existing Key
data "azurerm_key_vault_secret" "ssh_key" {
  count        = var.create_ssh ? 0 : 1
  name         = var.name_key
  key_vault_id = data.azurerm_key_vault.kv_ssh.id
}

resource "azurerm_key_vault_secret" "private_key" {
  count        = var.create_ssh ? 1 : 0
  name         = var.name_key
  value        = one(tls_private_key.default).private_key_pem
  key_vault_id = data.azurerm_key_vault.kv_ssh.id
}


