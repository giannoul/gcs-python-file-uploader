output "app_service_account_key_json" {
  description = "The Service Account JSON with keys"
  value       = base64decode(google_service_account_key.app_uploader.private_key)
  sensitive   = true
}