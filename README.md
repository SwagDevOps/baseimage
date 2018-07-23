# Alpine Server Image

Image based on ``alpine:3.8`` ([release notes][release:2018-06-26]).

This image consumes less than 6MB RAM (on startup).

```sh
rake restart && \
sleep 6 && \
for line in `docker ps | awk '{print $1}' | grep -v CONTAINER`; do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( `cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes` / 1024 / 1024 ))MB ; done | grep alpine_server
```

## Why?

### A complete init process

This image brings a 3 parts init system, composed of:

1. [``dumb-init``][dumb-init]
2. [``ylem``][ylem]
2. [``runit``][runit] services management + supervision

## Try

```
git clone git@github.com:SwagDevOps/image-alpine_server.git
cd image-alpine_server
bundle install --path vendor/bundle
bundle exec rake build start exec
```

## See also

* [A minimal Ubuntu base image][phusion/baseimage-docker]
* [Alpine image with environment template and supervisord][qenv/alpine-base]

[release:2018-06-26]: https://alpinelinux.org/posts/Alpine-3.8.0-released.html
[dumb-init]: https://github.com/Yelp/dumb-init
[ylem]: https://github.com/SwagDevOps/ylem
[runit]: http://smarden.org/runit/
[phusion/baseimage-docker]: https://github.com/phusion/baseimage-docker
[qenv/alpine-base]: https://github.com/qenv/alpine-base
