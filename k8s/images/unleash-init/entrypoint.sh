#!/usr/bin/env bash

if [[ -z "${UNLEASH_URL}" || -z "${API_TOKEN}" || -z "${USERS}" ]]; then
  echo "Invalid configuration..."
  exit 1
fi

until $(curl --output /dev/null --silent --head --fail $UNLEASH_URL); do
    printf 'Waiting for Unleash to become available...'
    sleep 5
done

IFS=', ' read -r -a users <<< $USERS
for user in "${users[@]}"
do
  IFS=': ' read -r -a user_data <<< $user
  user_id=$(curl \
    -H "Authorization: $API_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{ "email": "'${user_data[0]}'", "username": "'${user_data[1]}'", "rootRole": 1}' \
    "$UNLEASH_URL/api/admin/user-admin" \
  | jq '.id')

  curl \
    -H "Authorization: $API_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{ "password": "'${user_data[2]}'" }' \
    "$UNLEASH_URL/api/admin/user-admin/$user_id/change-password"
done

sleep infinity
