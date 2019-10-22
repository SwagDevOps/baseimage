# vim: ft=dockerfile
<?rb
Pathname.new(__dir__).join('helper.rb').tap do |file|
  self.instance_eval(file.read, file.to_s, 1)
end
?>

FROM #{quote(@from)}

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
    SVDIR=/var/services \
    SVWAIT=4

RUN apk add --no-cache #{Shellwords.join(packages)}

COPY build /build
RUN chmod -v 755 /build/run && \
    find /build/scripts/ -type f -maxdepth 1 -exec chmod -v 755 {} \; && \
    /build/run

COPY files /
COPY version.yml /etc/image.yml
RUN chmod 444 /etc/image.yml && \
    chmod -v 755 /boot/run /sbin/runsvdir-start && \
    find /boot/scripts/available/ -type f -maxdepth 1 -exec chmod -v 755 {} \; && \
    rsync -rua /etc/skel/.*[:alnum:]* /root/ && \
    find /root/ -type f -name ".*" -exec chmod -v 400 {} \; && \
    (cd /usr/bin && ln -s nvim vim)

ENTRYPOINT ["/boot/run"]
CMD ["runsvdir-start"]

# Local Variables:
# mode: Dockerfile
# End:
