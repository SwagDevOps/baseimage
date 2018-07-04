# Alpine Server Image

<!--
for line in `docker ps | awk '{print $1}' | grep -v CONTAINER`; do docker ps | grep $line | awk '{printf $NF" "}' && echo $(( `cat /sys/fs/cgroup/memory/docker/$line*/memory.usage_in_bytes` / 1024 / 1024 ))MB ; done
-->

This image only consumes 4MB RAM.

## Why?

### A complete init process

This image brings a 3 parts init system, the process is composed by:

1. [``dumb-init``][dumb-init]
2. ylem
2. runit

## See also

* [A minimal Ubuntu base image modified for Docker-friendliness][phusion/baseimage-docker]

[dumb-init]: https://github.com/Yelp/dumb-init
[phusion/baseimage-docker]: https://github.com/phusion/baseimage-docker
