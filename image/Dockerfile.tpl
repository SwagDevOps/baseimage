FROM alpine:3.8

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
        ruby-bigdecimal ruby-etc ruby-fiddle ruby-json && \
    rm -f /sbin/runit /etc/runit

COPY files /
RUN /build/build.sh

ENTRYPOINT ["/sbin/init", "-v", "--", "ylem", "start", "-v", "--"]
CMD ["/sbin/runsvdir-start"]

# Local Variables:
# mode: Dockerfile
# End:
