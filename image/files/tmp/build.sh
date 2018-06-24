#!/usr/bin/env sh

build() {
    (
        set -eu
        cd $(dirname -- "$(readlink -f -- "$0")")/build

        ls | sort | while read script; do
            test -r  "$script" || continue
            test -x  "$script" || continue

            echo "Executing ${script}"
            "./${script}" || return $?
        done
    )
}

build
