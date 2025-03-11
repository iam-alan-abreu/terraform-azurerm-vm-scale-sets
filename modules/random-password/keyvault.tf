data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "this" {
  name                = var.kv_name
  resource_group_name = var.kv_resource_group_name
  depends_on          = [random_password.password]
}

resource "azurerm_key_vault_secret" "win_pass" {
  name         = var.name_key
  value        = random_password.password.result
  key_vault_id = data.azurerm_key_vault.this.id

  depends_on = [random_password.password, data.azurerm_key_vault.this]
}


