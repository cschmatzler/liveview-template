module "mimir_bucket" {
  source = "./object_storage"

  name = "liveview-template-app-mimir"
}

module "loki_bucket" {
  source = "./object_storage"

  name = "liveview-template-app-loki"
}
