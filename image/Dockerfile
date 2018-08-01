FROM alpine:3.8
MAINTAINER Dimitri Arrigoni <dimitri@arrigoni.me>

ENV INITRD=no \
    TZ=Europe/Paris \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim \
    SVDIR=/service \
    SVWAIT=4

RUN apk add --no-cache \
        bash bash-completion htop screen \
        runit busybox file \
        curl sed tar grep shadow pwgen rsync \
        vim less coreutils sed procps \
        dropbear dropbear-convert tzdata \
        ruby ruby-bundler \
        ruby-bigdecimal ruby-etc ruby-fiddle ruby-json

COPY files /
RUN /build/build.sh

ENTRYPOINT ["/sbin/init", "-v", "--", "ylem", "start", "-v", "--"]
CMD ["/sbin/runsvdir-start"]
