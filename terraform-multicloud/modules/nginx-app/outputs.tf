# outputs for nginx-app module

output "app_url" {
  description = "URL to access the app"
  value       = "https://${var.lb_dns}"
}

output "info" {
  description = "deployment info"
  value       = "nginx app deployed, access at https://${var.lb_dns} (ignore browser warning for self-signed cert)"
}
