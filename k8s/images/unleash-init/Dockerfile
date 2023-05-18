FROM alpine:3.18.0

RUN apk add --no-cache bash curl

COPY ./k8s/images/unleash-init/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
