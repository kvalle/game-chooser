#!/usr/bin/env bash
set -e

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd $BASEDIR/..

if [ ! -d game-chooser-venv ]; then
    virtualenv game-chooser-venv
fi

source game-chooser-venv/bin/activate

pip install -r requirements.txt

echo "Done"
