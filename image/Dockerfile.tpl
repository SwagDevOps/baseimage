# vim: ft=dockerfile

FROM alpine:3.9.4

<?rb
self.singleton_class.__send__(:define_method, :quote) do |input|
  input.to_s.inspect
end
# @see http://label-schema.org/rc1/#label-semantics
?>
LABEL maintainer=#{quote('%s <%s>' % [@maintainer, @email])} \
      org.label-schema.name=#{quote(@image.name)} \
      org.label-schema.version=#{quote(@image.version)} \
      org.label-schema.url=#{quote(@homepage)}

ENV INITRD=no \
    TZ=UTC \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    EDITOR=vim \
    SVDIR=/var/service \
    SVWAIT=4

RUN apk add --no-cache \
        bash bash-completion htop multitail screen \
        runit dumb-init busybox libcap file tzdata \
        curl sed tar grep shadow pwgen rsync \
        vim less coreutils sed procps \
        dropbear dropbear-convert \
        ruby ruby-bundler \
        ruby-bigdecimal ruby-etc ruby-fiddle ruby-sdbm ruby-json

COPY build /build
RUN /build/run && \
    apk del --no-cache ruby-bundler
COPY files /
RUN rsync -rua /etc/skel/.*[:alnum:]* /root/

ENTRYPOINT ["/boot/run"]
CMD ["runsvdir-start"]

# Local Variables:
# mode: Dockerfile
# End:
