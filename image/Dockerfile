FROM alpine:3.8
MAINTAINER Dimitri Arrigoni <dimitri@arrigoni.me>

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim \
    INITRD=no \
    SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/service \
    SVDIR=/service \
    SVWAIT=4

RUN apk add --no-cache \
        bash bash-completion htop \
        runit busybox file \
        curl sed tar grep shadow pwgen rsync \
        vim less coreutils sed procps \
        dropbear \
        ruby ruby-bundler \
        ruby-bigdecimal ruby-etc ruby-fiddle ruby-json

COPY files /
RUN /build/build.sh

ENTRYPOINT ["/sbin/init", "-c", "--", "ylem", "start", "--verbose", "--"]
CMD ["/sbin/runsvdir-start"]
