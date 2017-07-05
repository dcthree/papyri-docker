#!/bin/bash

if [ -e "/repo/canonical_cloned.lock" ]; then
  exit 0
else
  exit 1
fi
