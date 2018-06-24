#!/usr/bin/env sh

build() {
    (
        set -eu
        export BUILD_PATH=$(dirname -- "$(readlink -f "$0")")

        ls "${BUILD_PATH}/build/"* | sort | while read script; do
            test -r  "$script" || continue
            test -x  "$script" || continue

            printf " ---> Building:%s\n" "${script}"
            "$script" || return $?
        done
    )
}

build
