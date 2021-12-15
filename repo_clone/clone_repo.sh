#!/bin/bash

BASE_PATH="/srv/data/papyri.info/sosol/repo"
REPO_PATH="${BASE_PATH}/canonical.git"
WORKING_COPY_PATH="/srv/data/papyri.info/idp.data"
LOCK_PATH="/srv/data/papyri.info/lockfiles/repo_clone"
LOCK_FILE="${LOCK_PATH}/canonical_cloned.lock"

mkdir -p "$LOCK_PATH"
# Uncomment to force re-clone:
# rm -rf $REPO_PATH $LOCK_FILE $WORKING_COPY_PATH
if [ ! -d "$REPO_PATH" ] && [ ! -e "$LOCK_FILE" ]; then
  echo "Cloning repo..."
  # git clone --bare https://github.com/papyri/idp.data.git $REPO_PATH && git clone --branch master --single-branch $REPO_PATH $WORKING_COPY_PATH
  git clone --bare /docker-compose/idp.data $REPO_PATH && git clone --branch master --single-branch $REPO_PATH $WORKING_COPY_PATH
  echo "repo clone done"
fi

if [ -d "$REPO_PATH" ] && [ ! -d "$WORKING_COPY_PATH" ] && [ ! -e "$LOCK_FILE" ]; then
  echo "Working copy doesn't exist, cloning..."
  git clone --branch master --single-branch $REPO_PATH $WORKING_COPY_PATH && touch "$LOCK_FILE"
fi

if [ -d "$REPO_PATH" ] && [ -d "$WORKING_COPY_PATH" ] && [ ! -e "$LOCK_FILE" ]; then
  echo "Repo already exists, touching $LOCK_FILE"
  touch "$LOCK_FILE"
fi

echo "repo clone finished"
