reset-db:
  mix ecto.drop
  mix ecto.create
  mix ecto.migrate

test:
  MIX_ENV=test just reset-db
  mix test

reset-assets:
  rm -rf priv/static/assets

deploy-assets: reset-assets
  npm i --prefix assets --ci
  mix tailwind default --minify
  mix esbuild default --minify
  mix phx.digest
