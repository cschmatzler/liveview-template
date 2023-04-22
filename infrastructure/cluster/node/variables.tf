variable "node_type" {
  type = string
}

variable "node_location" {
  type = string
}

variable "placement_group_id" {
  type     = number
  nullable = true
}

variable "network_id" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "rdns_domain" {
  type = string
}

variable "image_id" {
  type = string
}

variable "user_data" {
  type = string
}

variable "role" {
  type = string
}

variable "labels" {
  type     = map(any)
  nullable = true
}
