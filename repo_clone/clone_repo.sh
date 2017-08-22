#!/bin/bash

BASE_PATH="/srv/data/papyri.info/sosol/repo"
REPO_PATH="${BASE_PATH}/canonical.git"
LOCK_PATH="${BASE_PATH}/canonical_cloned.lock"

if [ ! -d "$REPO_PATH" ]; then
  git clone --bare --branch v1.0-rc1 --single-branch https://github.com/DCLP/idp.data.git $REPO_PATH && git clone --branch v1.0-rc1 --single-branch $REPO_PATH /srv/data/papyri.info/idp.data && touch "$LOCK_PATH"
else
  touch "$LOCK_PATH"
fi

sleep infinity
