#!/bin/sh

set -e

readonly DIR=$(readlink -m $(dirname $0))

main() {
    echo "[bootstrap] link Vagrantfile" && \
        ln -si $DIR/_Vagrantfile $DIR/../Vagrantfile
    echo "[bootstrap] create devstack.yaml" && \
        cp -i $DIR/devstack.yaml.dist $DIR/../devstack.yaml
}

main
