FROM alpine:3.18.0

ARG POSTGRES_VERSION
ENV POSTGRES_SUPER_USER="postgres"

RUN apk add --no-cache bash ca-certificates postgresql15-client~"${POSTGRES_VERSION}"

COPY ./k8s/images/postgresql-initdb/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
