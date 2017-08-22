#!/bin/bash

if [ -e "/srv/data/papyri.info/sosol/editor/editor.war.lock" ]; then
  exit 0
else
  exit 1
fi
