resource "grafana_user" "christoph" {
  provider = grafana.main
  email    = "christoph@medium.place"
  name     = "Christoph Schmatzler"
  login    = "christoph"
  password = var.user_christoph_password
}
