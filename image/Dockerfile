FROM alpine:3.7
MAINTAINER Dimitri Arrigoni <dimitri@arrigoni.me>

# Set environment
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim \
    PATH=/opt/local/bin:/opt/local/sbin:$PATH \
    INITRD=no

# Set environment for runit
ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/service  \
    SVDIR=${SERVICE_ENABLED_DIR}  \
    SVWAIT=7

# Define working directory.
WORKDIR /root

# Install files
COPY files /
RUN /tmp/build.sh \
    && rm -rf /var/cache/apk/* /tmp/*
