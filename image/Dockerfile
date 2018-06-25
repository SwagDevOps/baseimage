FROM alpine:3.7
MAINTAINER Dimitri Arrigoni <dimitri@arrigoni.me>

# Environment base
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim \
    INITRD=no

# Environment for runit
ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/service  \
    SVDIR=/service \
    SVWAIT=8

WORKDIR /root

COPY files /
RUN /tmp/build.sh

ENTRYPOINT ["init", "-c", "--", "ylem", "start", "--"]
CMD ["sleep", "infinity"]
