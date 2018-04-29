#!/usr/bin/env bash
set -e

if [ ! -d game-chooser-venv ]; then
    virtualenv game-chooser-venv
fi

source game-chooser-venv/bin/activate

pip install -r requirements.txt

echo "Done"
