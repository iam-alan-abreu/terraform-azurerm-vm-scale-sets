variable "extensions" {
  description = "Lista de configurações para cada extensão."
  type = list(object({
    enabled              = bool
    image_os             = string # Deve ser "Linux" ou "Windows"
    custom_name          = optional(string)
    workload             = optional(string)
    environment          = optional(string)
    publisher            = string
    type                 = string
    type_handler_version = string

    # Configurações dinâmicas para settings
    settings = optional(map(any), {}) # Mapa de valores estáticos
    settings_key_vault = optional(list(object({
      key                 = string # Nome da chave no JSON settings
      key_vault_name      = string
      resource_group_name = string
      secret_name         = string
    })), [])

    # Configurações dinâmicas para protected_settings
    protected_settings = optional(map(any), {}) # Mapa de valores estáticos
    protected_settings_key_vault = optional(list(object({
      key                 = string # Nome da chave no JSON protected_settings
      key_vault_name      = string
      resource_group_name = string
      secret_name         = string
    })), [])

    auto_upgrade_minor_version = optional(bool, false)
    automatic_upgrade_enabled  = optional(bool, false)
    tags                       = optional(map(string))
    use_protected_settings     = optional(bool, false)
  }))
}

variable "virtual_machine_id" {
  type = string
}
