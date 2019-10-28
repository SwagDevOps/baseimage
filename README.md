# Alpine Server Image

Image based on ``alpine:3.10.3`` ([release notes][release:2019-10-21]).

This image SHOULD consume less than 6MB RAM on startup (depending on RAM installed).

```sh
rake restart && \
sleep 6 && \
docker ps | awk '{print $1}' | grep -v CONTAINER | while read line; do docker ps | grep $line | awk '{printf $NF" "}' && echo "scale=2; $(cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes)/1024/1024" | bc -l; done | sort | column -t
```

For an image size around ``56MB``.

<a name="why"></a>
## Why?

<a name="init_process"></a>
### A complete init process

This image brings a 3 parts init system, composed of:

1. [``ylem``][ylem] startup scripts execution
2. [``dumb-init``][dumb-init] minimal init system for Linux containers
3. [``runit``][runit] services management

It would solve [the PID 1 problem][blog.phusion.nl:docker-and-the-pid-1-zombie-reaping-problem].

<a name="try"></a>
## Try

### From sources

```sh
git clone git@github.com:SwagDevOps/image-alpine_server.git
cd image-alpine_server
bundle install --path vendor/bundle --without development
bundle exec rake build start exec
```

### From docker hub

```sh
docker run -d --rm --name trying.alpine_server swagdevops/alpine_server:VERSION

```

```sh
docker exec -ti trying.alpine_server bash -l
```

<a name="tests"></a>
## Run tests

```sh
mkdir -p ssh/authorized_keys
cp ~/.ssh/id_rsa.pub ssh/authorized_keys/root
bundle exec rake restart test
```

Tests are executed over ``SSH``, and rely on minimal (host) dependencies.

<a name="using"></a>
## Using as base image

<a name="getting_started"></a>
### Getting started

The image is called [``swagdevops/alpine_server``][docker_hub.com:swagdevops/alpine_server],
and is available on the Docker registry.

Use ``swagdevops/alpine_server`` as base image.

```dockerfile
FROM swagdevops/alpine_server:VERSION
```

To make your builds reproducible, you MUST lock down
to a specific version, DO NOT use [`latest`][vsupalov.com:wrong-with-latest].
ATM, `latest` tag does not exist, as a result: you CAN NOT use it.

See [releases][github.com:swagdevops/alpine/server/releases]
for a list of version numbers.

<a name="see_also"></a>
## See also

* [A minimal Ubuntu base image][phusion/baseimage-docker]
* [Alpine image with environment template and supervisord][qenv/alpine-base]

* [Petit état de l'art des systèmes d'initialisation][linuxfr:petit-etat-de-l-art]

<!-- hyperlinks references -->

[release:2019-10-21]: https://alpinelinux.org/posts/Alpine-3.10.3-released.html
[release:2019-08-20]: https://alpinelinux.org/posts/Alpine-3.10.2-released.html
[release:2019-05-09]: https://alpinelinux.org/posts/Alpine-3.9.4-released.html
[release:2019-01-29]: https://alpinelinux.org/posts/Alpine-3.9.0-released.html
[release:2018-06-26]: https://alpinelinux.org/posts/Alpine-3.8.0-released.html
[dumb-init]: https://github.com/Yelp/dumb-init
[ylem]: https://github.com/SwagDevOps/ylem
[runit]: http://smarden.org/runit/
[blog.phusion.nl:docker-and-the-pid-1-zombie-reaping-problem]: https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
[phusion/baseimage-docker]: https://github.com/phusion/baseimage-docker
[qenv/alpine-base]: https://github.com/qenv/alpine-base
[linuxfr:petit-etat-de-l-art]: https://linuxfr.org/news/petit-etat-de-l-art-des-systemes-d-initialisation-1
[docker_hub.com:swagdevops/alpine_server]: https://hub.docker.com/r/swagdevops/alpine_server
[github.com:swagdevops/alpine/server/releases]: https://github.com/SwagDevOps/image-alpine_server/releases
[vsupalov.com:wrong-with-latest]: https://vsupalov.com/docker-latest-tag/
