#!/bin/bash

if [ -e "/srv/data/papyri.info/sosol/repo/canonical_cloned.lock" ]; then
  exit 0
else
  exit 1
fi
