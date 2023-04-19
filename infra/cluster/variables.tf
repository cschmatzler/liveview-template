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

variable "network_id" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "x86_image_id" {
  type = string
}

variable "arm_image_id" {
  type = string
}
