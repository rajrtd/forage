# ===========
# Outputs
# ===========
output "load_balancer_public_ip" {
  description = "The public IP address of the load balancer"
  value       = azurerm_public_ip.lb_public_ip.ip_address
}
