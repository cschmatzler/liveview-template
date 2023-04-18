#!/bin/sh

set -eo pipefail
set -a

source $1.secret.env
sops --age $AGE_PUBLIC_KEY --input-type dotenv -e $1.secret.env > $1.env.enc
gomplate -f $1.tpl | sops --age $AGE_PUBLIC_KEY --input-type yaml --encrypted-regex '^(data|stringData)$' -e /dev/stdin > $1.enc
