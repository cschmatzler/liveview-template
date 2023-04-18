variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_token" {
  type      = string
  sensitive = true
}

variable "domain" {
  type = string
}

variable "image_id" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "public_key_path" {
  type = string
}
