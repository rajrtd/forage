variable subscription_id {
  description = "The Azure subscription ID to use for the provider."
  type        = string
}

variable tenant_id {
  description = "The Azure tenant ID to use for the provider."
  type        = string
}

variable vm_password {
  description = "The password for the virtual machines. Ensure it meets Azure's password complexity requirements."
  type        = string
  sensitive   = true
}