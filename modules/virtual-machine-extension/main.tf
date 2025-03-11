
data "azurerm_key_vault" "this" {
  for_each = { for ext in var.extensions : ext.custom_name => ext if ext.enabled && (length(ext.settings_key_vault) > 0 || length(ext.protected_settings_key_vault) > 0) }

  name                = each.value.settings_key_vault[0].key_vault_name != "" ? each.value.settings_key_vault[0].key_vault_name : each.value.protected_settings_key_vault[0].key_vault_name
  resource_group_name = each.value.settings_key_vault[0].resource_group_name != "" ? each.value.settings_key_vault[0].resource_group_name : each.value.protected_settings_key_vault[0].resource_group_name
}

data "azurerm_key_vault_secret" "settings" {
  for_each = { for ext in var.extensions : ext.custom_name => ext if ext.enabled && length(ext.settings_key_vault) > 0 }

  name         = each.value.settings_key_vault[0].secret_name
  key_vault_id = data.azurerm_key_vault.this[each.key].id
}

data "azurerm_key_vault_secret" "protected_settings" {
  for_each = { for ext in var.extensions : ext.custom_name => ext if ext.enabled && length(ext.protected_settings_key_vault) > 0 }

  name         = each.value.protected_settings_key_vault[0].secret_name
  key_vault_id = data.azurerm_key_vault.this[each.key].id
}


resource "time_sleep" "wait" {
  create_duration = "120s"
}

resource "azurerm_virtual_machine_extension" "this" {
  for_each = { for ext in var.extensions : ext.custom_name => ext if ext.enabled != "" }

  name                 = coalesce(each.value.custom_name, "${split("/", var.virtual_machine_id)[length(split("/", var.virtual_machine_id)) - 1]}-${each.value.type}")
  virtual_machine_id   = var.virtual_machine_id
  publisher            = each.value.publisher
  type                 = each.value.type
  type_handler_version = each.value.type_handler_version
  settings = jsonencode(merge(each.value.settings, {
    for s in each.value.settings_key_vault : s.key => try(data.azurerm_key_vault_secret.settings[each.key].value, null)
  }))
  protected_settings = each.value.use_protected_settings ? jsonencode(merge(each.value.protected_settings, {
    for ps in each.value.protected_settings_key_vault : ps.key => try(data.azurerm_key_vault_secret.protected_settings[each.key].value, null)
  })) : null
  automatic_upgrade_enabled  = each.value.automatic_upgrade_enabled
  auto_upgrade_minor_version = each.value.auto_upgrade_minor_version
  tags                       = each.value.tags

  depends_on = [time_sleep.wait]
}


