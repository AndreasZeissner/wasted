#!/bin/sh

set -e

readonly DIR=$(readlink -m $(dirname $0))

main() {
    echo "[bootstrap] link Vagrantfile to project root" && \
        ln -si $DIR/Vagrantfile $DIR/../Vagrantfile
    echo "[bootstrap] link .vagrant to project root" && \
        ln -si $DIR/.vagrant $DIR/../.vagrant
    echo "[bootstrap] create devstack.yaml in project root" && \
        cp -i $DIR/devstack.yaml.dist $DIR/../devstack.yaml
}

main
