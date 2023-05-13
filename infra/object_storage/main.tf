terraform {
  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.4"
    }
  }
}

resource "b2_bucket" "bucket" {
  bucket_name = var.name
  bucket_type = "allPrivate"
}

# TODO: ship this into 1Password directly once the Terraform provider supports service accounts
resource "b2_application_key" "application_key" {
  key_name     = var.name
  capabilities = ["listFiles", "readFiles", "writeFiles", "deleteFiles"]
  bucket_id = b2_bucket.bucket.id
}
