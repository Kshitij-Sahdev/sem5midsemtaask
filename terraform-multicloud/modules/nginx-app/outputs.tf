# outputs for nginx-app module

output "app_url" {
  description = "URL to access the app"
  value       = var.enable_application && var.lb_dns != "" ? "https://${var.lb_dns}" : ""
}

output "info" {
  description = "Deployment metadata"
  value = var.enable_application ? {
    name        = local.app_name
    project     = var.project_name
    environment = var.environment
    endpoint    = var.lb_dns != "" ? "https://${var.lb_dns}" : ""
    note        = "Self-signed certificate will trigger a browser warning unless replaced with a trusted cert."
  } : {}
}
