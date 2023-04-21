FROM alpine:3.17.2

ARG POSTGRES_VERSION
ENV POSTGRES_SUPER_USER="postgres"

RUN apk add --no-cache ca-certificates postgresql15-client~"${POSTGRES_VERSION}"

COPY ./kubernetes/images/postgresql-initdb/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
