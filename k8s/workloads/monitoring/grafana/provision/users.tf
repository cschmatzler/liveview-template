resource "random_string" "password" {
  length = 48
}

resource "grafana_user" "christoph" {
  provider = grafana.main
  email    = "christoph@medium.place"
  name     = "Christoph Schmatzler"
  login    = "christoph"
  password = random_string.password.result
}
