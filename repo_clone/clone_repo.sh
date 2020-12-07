#!/bin/bash

BASE_PATH="/srv/data/papyri.info/sosol/repo"
REPO_PATH="${BASE_PATH}/canonical.git"
LOCK_PATH="/srv/data/papyri.info/lockfiles/repo_clone"
LOCK_FILE="${LOCK_PATH}/canonical_cloned.lock"

mkdir -p "$LOCK_PATH"
if [ ! -d "$REPO_PATH" ]; then
  echo "Cloning repo..."
  git clone --bare https://github.com/papyri/idp.data.git $REPO_PATH && git clone --branch master --single-branch $REPO_PATH /srv/data/papyri.info/idp.data && touch "$LOCK_FILE"
  echo "repo clone done"
elif [ ! -d "/srv/data/papyri.info/idp.data" ]; then
  echo "Working copy doesn't exist, cloning..."
  git clone --branch master --single-branch $REPO_PATH /srv/data/papyri.info/idp.data && touch "$LOCK_FILE"
else
  echo "Repo already exists, touching $LOCK_FILE"
  touch "$LOCK_FILE"
fi

echo "repo clone finished"
# sleep infinity
