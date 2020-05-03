FROM scratch
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

FROM alpine:latest AS build-common
ARG RCLONE_VERSION=1.51.0

FROM build-common AS build-linux-i386
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-386.zip

FROM build-common AS build-linux-amd64
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip


FROM build-common AS build-windows-i386
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-windows-386.zip

FROM build-common AS build-windows-amd64
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-windows-amd64.zip


FROM build-common AS build-linux-arm-v7
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm.zip

FROM build-common AS build-linux-arm-v8
ARG RCLONE_PKG_URL=https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm64.zip


FROM build-${TARGETOS}-${TARGETARCH}${TARGETVARIANT:+-$TARGETVARIANT}
LABEL maintainer="michael.l.vogel@gmail.com"

RUN apk update --no-cache \
    && apk add --no-cache \
        openssl \
        ca-certificates \
        fuse \
    && cd /tmp \
    && wget -q $RCLONE_PKG_URL \
    && unzip ./rclone-*.zip \
    && mv ./rclone-*/rclone /usr/bin \
    && rm -r ./rclone-*

ENTRYPOINT ["/usr/bin/rclone"]

CMD ["--version"]