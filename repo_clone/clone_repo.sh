#!/bin/bash

REPO_PATH="/repo/canonical.git"

if [ ! -d "$REPO_PATH" ]; then
  git clone --bare --branch v1.0-rc1 --single-branch https://github.com/DCLP/idp.data.git $REPO_PATH && touch "/repo/canonical_cloned.lock"
else
  touch "/repo/canonical_cloned.lock"
fi
