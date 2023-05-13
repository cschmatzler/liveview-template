terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "1.40.1"
    }
  }

  backend "s3" {
    endpoint                    = "https://s3.eu-central-2.wasabisys.com"
    region                      = "eu-central-2"
    bucket                      = "liveview-template-app-tfstate"
    force_path_style            = true
    key                         = "monitoring-grafana-provision.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "grafana" {
  alias = "main"
  url   = "https://grafana.liveview-template.app/"
  auth  = var.admin_auth
}
