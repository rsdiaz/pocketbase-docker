FROM alpine:latest as downloader

ARG VERSION=0.11.4

RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_linux_amd64.zip \
  && unzip pocketbase_${VERSION}_linux_amd64.zip \
  && chmod +x /pocketbase

FROM alpine:latest

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

EXPOSE 8282

COPY --from=downloader /pocketbase /usr/local/bin/pocketbase
ENTRYPOINT ["/usr/local/bin/pocketbase", "serve", "--http=0.0.0.0:8282", "--dir=/pb_data", "--publicDir=/pb_public"]