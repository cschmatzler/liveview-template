output "application_key_id" {
  value = b2_application_key.application_key.application_key_id
  sensitive = true
}

output "application_key" {
  value = b2_application_key.application_key.application_key
  sensitive = true
}
