#!/bin/bash

BASE_PATH="/srv/data/papyri.info/sosol/repo"
REPO_PATH="${BASE_PATH}/canonical.git"
LOCK_PATH="${BASE_PATH}/canonical_cloned.lock"

if [ ! -d "$REPO_PATH" ]; then
  echo "Cloning repo..."
  git clone --bare https://github.com/DCLP/idp.data.git $REPO_PATH && git clone --branch master --single-branch $REPO_PATH /srv/data/papyri.info/idp.data && touch "$LOCK_PATH"
elif [ ! -d "/srv/data/papyri.info/idp.data" ]; then
  echo "Working copy doesn't exist, cloning..."
  git clone --branch master --single-branch $REPO_PATH /srv/data/papyri.info/idp.data && touch "$LOCK_PATH"
else
  echo "Repo already exists, touching $LOCK_PATH"
  touch "$LOCK_PATH"
fi

sleep infinity
