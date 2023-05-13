variable "hcloud_token" {
  type      = string
  sensitive = true
  default   = env("HCLOUD_TOKEN")
}

variable "cloudflare_token" {
  type      = string
  sensitive = true
  default   = env("CLOUDFLARE_TOKEN")
}
