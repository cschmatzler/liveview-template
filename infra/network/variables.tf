variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "domain" {
  type = string
}

variable "public_key_path" {
  type = string
}
