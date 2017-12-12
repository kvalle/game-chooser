#/bin/bash

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd "${BASEDIR}/.."

if [[ "$#" != "1" ]]; then
  echo "Usage: ${0} game-<environment>"
  exit 1
elif [[ ${1} == "game-prod" ]]; then
  BUCKET="game.kjetilvalle.com"
elif [[ ${1} == "game-test" ]]; then
  BUCKET="test.game.kjetilvalle.com"
else
  echo "Environment not recognized: '$1'."
  exit 1
fi

npm run build

aws s3 sync ./build/ "s3://${BUCKET}" --delete --profile "game-chooser"
