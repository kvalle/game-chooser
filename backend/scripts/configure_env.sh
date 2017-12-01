#!/usr/bin/env bash
set -e

# find folder script is located in
BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# resolve symlinks
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done

# move to folder above the scripts
cd "$BASEDIR/.."

read -p "Environment? " ENV

ansible-vault view secretconfig/$ENV-config.py > app/config.py
ansible-vault view secretconfig/$ENV-firebase-serviceAccountKey.json > firebase-serviceAccountKey.json
