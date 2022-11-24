import Config

if System.get_env("ENABLE_SERVER") do
  config :leuchtturm, Leuchtturm.Web.Endpoint, server: true
end

# ---------
# Production
# ---------
if config_env() == :prod do
  # ---------
  # Telemetry
  # ---------
  namespace = System.fetch_env!("TELEMETRY_NAMESPACE")
  lightstep_access_token = System.fetch_env!("LIGHTSTEP_ACCESS_TOKEN")

  config :opentelemetry, :resource,
    service: %{
      name: "leuchtturm.io",
      namespace: namespace
    },
    env: namespace

  config :opentelemetry,
    span_processor: :batch,
    traces_exporter: :otlp

  config :opentelemetry, :processors,
    otel_batch_processor: %{
      exporter: {
        :opentelemetry_exporter,
        %{
          endpoints: [
            {:https, "ingest.lightstep.com", 443,
             [
               verify: :verify_peer,
               cacertfile: :certifi.cacertfile(),
               depth: 3,
               customize_hostname_check: [
                 match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
               ]
             ]}
          ],
          headers: [
            {"lightstep-access-token", lightstep_access_token},
          ],
          protocol: :grpc
        }
      }
    }

  # --------
  # Database
  # --------
  database_url = System.fetch_env!("DATABASE_URL")

  config :leuchtturm, Leuchtturm.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # ---
  # Web
  # ---
  host = System.get_env("HOST") || "leuchtturm.io"
  port = String.to_integer(System.get_env("PORT") || "4000")
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

  config :leuchtturm, Leuchtturm.Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      port: port
    ],
    secret_key_base: secret_key_base

  # ----
  # Mail
  # ----
  config :leuchtturm, Leuchtturm.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    api_key: System.fetch_env!("POSTMARK_API_KEY")
end
