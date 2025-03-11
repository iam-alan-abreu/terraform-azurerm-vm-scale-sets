output "key_name" {
  value       = module.this.id
  description = "Name of SSH key"
}

output "private_key" {
  value       = var.private_key_output_enabled ? one(tls_private_key.default).private_key_pem : null
  description = "Content of the generated private key"
  sensitive   = true
}

output "public_key" {
  value       = var.create_ssh ? join("", tls_private_key.default.*.public_key_openssh) : one(data.azurerm_key_vault_secret.ssh_key).value
  description = "Id of the generated public key on ssh"
}
