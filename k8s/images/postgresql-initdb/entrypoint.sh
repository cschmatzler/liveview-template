#!/usr/bin/env bash

export PGHOST="${POSTGRES_HOST}"
export PGUSER="${POSTGRES_SUPERUSER}"
export PGPASSWORD="${POSTGRES_SUPERUSER_PASSWORD}"

if [[ -z "${PGHOST}" || -z "${PGUSER}" || -z "${PGPASSWORD}" || -z "${POSTGRES_USER}" || -z "${POSTGRES_PASSWORD}" || -z "${POSTGRES_DB}" ]]; then
  echo "Invalid configuration..."
  exit 1
fi

until pg_isready; do
  sleep 1
done

user_exists=$(\
  psql \
    --tuples-only \
    --csv \
    --command "SELECT 1 FROM pg_roles WHERE rolname = '${POSTGRES_USER}'"
  )

if [[ -z "${user_exists}" ]]; then
  createuser ${POSTGRES_USER_FLAGS} "${POSTGRES_USER}"
  psql --command "alter user \"${POSTGRES_USER}\" with encrypted password '${POSTGRES_PASSWORD}';"
fi

database_exists=$(\
  psql \
    --tuples-only \
    --csv \
    --command "SELECT 1 FROM pg_database WHERE datname = '${POSTGRES_DB}'"
  )

if [[ -z "${database_exists}" ]]; then
  createdb --owner "${POSTGRES_USER}" "${POSTGRES_DB}"
fi

psql --command "grant all privileges on database \"${POSTGRES_DB}\" to \"${POSTGRES_USER}\";"

