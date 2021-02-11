#!/bin/bash

set -e

# Skip the postinstall script if we're already rebuilding,
# to avoid an endless, recursive postinstall loop.
if [ -n "${APM_ALREADY_REBUILDING}" ]; then
  echo ">> Postinstall script is already being run. Skipping recursive call."
  exit 0
fi

echo ">> Downloading bundled Node"
node script/download-node.js

echo
echo ">> Rebuilding apm dependencies with bundled Node $(./bin/node -p "process.version + ' ' + process.arch")"
export APM_ALREADY_REBUILDING="true"
./bin/npm rebuild

echo
if [ -z "${NO_APM_DEDUPE}" ]; then
  echo ">> Deduping apm dependencies"
  ./bin/npm dedupe
else
  echo ">> Deduplication disabled"
fi
