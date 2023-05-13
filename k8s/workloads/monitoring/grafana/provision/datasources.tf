resource "grafana_data_source" "mimir" {
  provider           = grafana.main
  type               = "prometheus"
  name               = "Mimir"
  url                = "http://mimir-query-frontend.monitoring.svc.cluster.local:8080/prometheus"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    httpMethod      = "POST"
    prometheusType  = "Mimir"
    manageAlerts    = false
    httpHeaderName1 = "X-Scope-OrgID"
  })

  secure_json_data_encoded = jsonencode({
    httpHeaderValue1 = "liveview-template.app"
  })
}

resource "grafana_data_source" "loki" {
  provider           = grafana.main
  type               = "loki"
  name               = "Loki"
  url                = "http://loki-gateway.monitoring.svc.cluster.local"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    maxLines        = 250
    httpMethod      = "POST"
    manageAlerts    = false
    httpHeaderName1 = "X-Scope-OrgID"
  })

  secure_json_data_encoded = jsonencode({
    httpHeaderValue1 = "liveview-template.app"
  })
}

resource "grafana_data_source" "tempo" {
  provider           = grafana.main
  type               = "tempo"
  name               = "Tempo"
  url                = "http://tempo-query-frontend.monitoring.svc.cluster.local:3100"
  basic_auth_enabled = false

  json_data_encoded = jsonencode({
    httpMethod      = "POST"
    httpHeaderName1 = "X-Scope-OrgID"
  })

  secure_json_data_encoded = jsonencode({
    httpHeaderValue1 = "liveview-template.app"
  })
}
