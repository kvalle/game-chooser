#!/usr/bin/env bash
set -e

WATCH=false

# Handle script options
while test $# -gt 0
do
    case "$1" in
        --watch)
          WATCH=true
          ;;
        --*)
          echo "Unexpected option: $1"
          echo
          print_help
          exit 1
          ;;
        *)
          echo "Unexpected argument: $1"
          echo
          print_help
          exit 1
          ;;
    esac
    shift
done

# Make sure we know where we are
SCRIPT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$SCRIPT_DIR/$0" ]; do
    DIR=$(dirname -- "$SCRIPT_DIR/$0")
    SYM=$(readlink $SCRIPT_DIR/$0)
    SCRIPT_DIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
BASEDIR="${SCRIPT_DIR}/.."
cd ${BASEDIR}

if [ -z ${VIRTUAL_ENV} ]; then
  source game-chooser-venv/bin/activate
fi

function build() {
  # Make sure build dir is present and empty
  mkdir -p build
  rm -rf build/*

  # Build zip with python dependencies
  cd ${VIRTUAL_ENV}/lib/python2.7/site-packages/
  zip -r $BASEDIR/build/package.zip *

  # Add lambda code to the bundle
  cd $BASEDIR/fetch-collection
  zip $BASEDIR/build/package.zip *

  echo "[Done]"
}

function watch_build() {
  if command -v inotifywait >/dev/null; then
    echo -e "\033[1;37m> Prepared to run tests on new changes..\033[0m"
    while inotifywait -q -r -e modify $BASEDIR/fetch-collection ; do
      build
    done

  elif command -v fswatch >/dev/null; then
    echo -e "\033[1;37m> Prepared to run tests on new changes..\033[0m"
    fswatch $BASEDIR/fetch-collection | (while read; do build; done)
  else
    echo "Unable to run watch. Make sure you have inotifytools (linux) or fswatch (mac) installed."
  fi
}

build

if ${WATCH} ; then
  watch_build
fi
