output "christoph_password" {
  value = random_string.password.result
  sensitive = true
}
