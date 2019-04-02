#
# Dockerfile for frp
#

FROM alpine
LABEL maintainer="Ricky Li <cnrickylee@gmail.com>"

RUN set -ex \
 # Build environment setup
 && apk update \
 && apk upgrade \
 && apk add --no-cache --virtual .build-deps \
      git \
      make \
      go \
      musl-dev \
 # Build & install
 && mkdir -p /tmp/repo \
 && cd /tmp/repo \
 && git clone https://github.com/m13253/dns-over-https.git \
 && cd dns-over-https \
 && make \
 && install doh-client/doh-client /usr/local/bin \
 && install doh-server/doh-server /usr/local/bin \
 && cd / \
 && rm -rf /tmp/repo \
 && rm -rf $(go env GOPATH) \
 && rm -rf $(go env GOCACHE) \
 && go clean \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
 && doh-client -version \
 && doh-server -version

USER root

