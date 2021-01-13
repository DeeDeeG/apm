#!/bin/bash

set -e

echo ">> Downloading bundled Node"
node script/download-node.js

echo
echo ">> Rebuilding apm dependencies with bundled Node $(./bin/node -p "process.version + ' ' + process.arch")"

# parallel node-gyp
JOBS=16

./bin/npm rebuild

echo
if [ -n "${APM_DEDUPE}" ]; then
  echo ">> Deduping apm dependencies"
  ./bin/npm dedupe
fi
