module "postgresql_main_bucket" {
  source = "./object_storage/"

  name = "liveview-template-app-postgresql-main"
}

module "mimir_bucket" {
  source = "./object_storage"

  name = "liveview-template-app-mimir"
}

module "loki_bucket" {
  source = "./object_storage"

  name = "liveview-template-app-loki"
}

module "tempo_bucket" {
  source = "./object_storage"

  name = "liveview-template-app-tempo"
}
